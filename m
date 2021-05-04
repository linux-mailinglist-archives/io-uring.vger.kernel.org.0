Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F69372FAC
	for <lists+io-uring@lfdr.de>; Tue,  4 May 2021 20:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbhEDSZC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 May 2021 14:25:02 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:51874 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbhEDSZB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 May 2021 14:25:01 -0400
X-Greylist: delayed 1027 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 May 2021 14:25:01 EDT
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:55138 helo=[192.168.1.177])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <olivier@trillion01.com>)
        id 1ldzRj-0003xN-3C
        for io-uring@vger.kernel.org; Tue, 04 May 2021 14:06:59 -0400
Message-ID: <8992f5f989808798ad2666b0a3ef8ae8d777b7de.camel@trillion01.com>
Subject: IORING_OP_POLL_ADD/IORING_OP_POLL_REMOVE questions
From:   Olivier Langlois <olivier@trillion01.com>
To:     io-uring <io-uring@vger.kernel.org>
Date:   Tue, 04 May 2021 14:06:58 -0400
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

I have started to use io_uring with kernel 5.11.16 and libev 4.33.

Actually, I did significantly change libev code mostly to use liburing
instead of replacing most of its boilerplace code for my prototype.

There is no SQPOLL thread in my setup. io_uring initialisation is as
plain as it can be:

ecb_cold
static int
iouring_internal_init (EV_P)
{
  struct io_uring_params params = { 0 };

  if (!have_monotonic) /* cannot really happen, but what if!! */
    return -1;

  if (io_uring_queue_init_params(iouring_entries, &iouring_ring,
&params) < 0)
    return -1;

  return 0;
}

I use io_uring for polling O_NONBLOCK TCP sockets.

For the most part, io_uring works as expected EXCEPT for this scenario:

I want to update the polling mask from POLLIN to POLLIN|POLLOUT.

To achieve that, I do submit to SQEs:

inline_speed
void *
iouring_build_user_data(char type, int fd, uint32_t egen)
{
    return (void *)((uint32_t)fd | ((__u64)(egen && 0x00ffffff) << 32 )
|
                    ((__u64)type << 56));
}

inline_speed
void
iouring_decode_user_data(uint64_t data, char *type, int *fd, uint32_t
*egen)
{
  *type = data >> 56;
  *fd   = data & 0xffffffffU;
  *egen = (data >> 32) & 0x00ffffffU;
}

          struct io_uring_sqe *sqe = iouring_sqe_get (EV_A);
          printf("%d %d remove %d %u\n", oev, nev, fd, (uint32_t)anfds
[fd].egen);
          io_uring_prep_poll_remove(sqe,
iouring_build_user_data(IOURING_POLL, fd, anfds [fd].egen));
//          io_uring_sqe_set_data(sqe,
iouring_build_user_data(IOURING_POLL, fd, anfds [fd].egen));

          /* increment generation counter to avoid handling old events
*/
          ++anfds [fd].egen;

          struct io_uring_sqe *sqe = iouring_sqe_get (EV_A);
          io_uring_prep_poll_add(sqe, fd, (nev & EV_READ ? POLLIN : 0)
| (nev & EV_WRITE ? POLLOUT : 0));
          io_uring_sqe_set_data(sqe,
iouring_build_user_data(IOURING_POLL, fd, anfds [fd].egen));
printf("%d %d add %d %u\n", oev, nev, fd, (uint32_t)anfds [fd].egen);

Followed by a io_uring_enter() call buried in liburing code to submit the 2 sqes at the same time:

inline_speed
int
iouring_enter (EV_P_ ev_tstamp timeout)
{
  int res;
  struct __kernel_timespec ts;
  struct io_uring_cqe *cqe_ptr;
  EV_TS_SET(ts, timeout);
  EV_RELEASE_CB;

  res = io_uring_wait_cqe_timeout(&iouring_ring, &cqe_ptr, &ts);

  EV_ACQUIRE_CB;

  return res;
}

On the CQE processing side, I have the following trace:

// fd is hardcoded to filter out all the calls working fine
if (fd == 85)
            printf("85 gen %d res %d\n", (uint32_t)gen, res);

Here is the output:
85 gen 1 res 195
0 1 add 85 1

// Those 2 sqes are submitted at the same time
1 3 remove 85 1
1 3 add 85 2

85 gen 1 res -125
85 gen 1 res 4

When I receive '85 gen 1 res 4', it is discarded because gen 1 poll
request has been cancelled. The code will process gen 2 cqes from
there.

My '1 3 add 85 2' sqe has been silently discarded. After 1 minute of
unexpected fd inactivity, I try to remove my gen 2 POLL request and it
result to a cqe reporting an ENOENT error.

1. 195 is the cqe result for a successful IORING_OP_POLL_ADD
submission. I only check the POLLIN|POLLOUT bits. What is the meaning
of the other bits?

2. I don't understand what I am looking at. Why am I receiving a
completion notification for a POLL request that has just been
cancelled? What is the logic behind silently discarding a
IORING_OP_POLL_ADD sqe meant to replace an existing one?

3. As I am writing this email, I have just noticed that it was possible
to update an existing POLL entry with IORING_OP_POLL_REMOVE through
io_uring_prep_poll_update(). Is this what I should do to eliminate my
problems? What are the possible race conditions scenarios that I should
be prepared to handle by using io_uring_prep_poll_update() (ie:
completion of the poll entry to update while my process is inside
io_uring_enter() to update it...)?

thx a lot for your guidance in my io_uring journey!
Olivier


