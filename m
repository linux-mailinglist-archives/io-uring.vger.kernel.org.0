Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 266D9528494
	for <lists+io-uring@lfdr.de>; Mon, 16 May 2022 14:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbiEPMvS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 May 2022 08:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236248AbiEPMvB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 May 2022 08:51:01 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53962DEE2
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 05:50:59 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id r30so2663317wra.13
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 05:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9x+XD4JttqTK6VHrpNpRp1Hk6E9jiAJJFmgyRMQnaDc=;
        b=MzY/3jaZNEcc9WkeVAUwSo5sSMoUCeWvodqoKLPLqKNaxOlvQFH+z6ActNDmJw9K0N
         W7MwU/CiUEZrWjYfUW8uaOIqmQ2Nbl6xYtVZ6wLmY48wVozf+OS7kxKYsgHM5CnYCrMW
         jcU51myq42trQyUK3oyimZeL3/RQQSK62U415yBiu96QVKuBor5C7CTIPISmGeZc0VXa
         3L9YG6IS4QOx52nLiFcB7uGO1wEYOgbwZzT0pau2wDpDWF6eXsJq1ePIwTsp97CY99oo
         hXLq6INda7NZBpxyiT4eYACHS9VbqhXaFr5UA488BPl/URRKdIcl3ATJlAXtZpD3lczv
         qRUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9x+XD4JttqTK6VHrpNpRp1Hk6E9jiAJJFmgyRMQnaDc=;
        b=t9MrZzHt3kzORUfIu15ImwXUZZ0tPOnlEcX7zZUTbW9ABkLlYNO1eW+JX4dbXBiNfZ
         xL3N2PAg3RqBhRstDvRpxuhpgNdzRedsJfI6bcLUBn7YRkx4l7/4o4ApvgkGC6KRWzLN
         1wKpgjALZFfqSCj5wh/hKg87/iwhc9QU3FszUg8+371a9/DK0gDOlzat8APKJLAXmI/V
         NtaWoYLz+MS0B1dfwHxN8zmhGNjBsFBy+QaOAELeR04HsKs7S3WMP/eHWM2BdW2lFJJA
         CQ7E33M6vFdaQz6LV2xmIXKCrG+ecKFCHMlEByRQhd9A2TFlo/6cqqw0hVwHpGouOzJQ
         Cmww==
X-Gm-Message-State: AOAM530M/vOl67VoR3QaVxm20u+dnf5fCgLwRim2jENkXGgEG5ozwDOn
        rf5q5qNFBJsuNPIH2iAV+gV89k0mCB9aFAEGv2EdjmRPWeCx/g==
X-Google-Smtp-Source: ABdhPJwFc+pZMscTyQ0VSdofpUy/5L8kQhASTp3jv63llmA8ufDEv7zoMp1FolXnrUdBJ5MwXNGhjyGSV87WeceBvBM=
X-Received: by 2002:a05:6000:1845:b0:20c:5b3c:bde8 with SMTP id
 c5-20020a056000184500b0020c5b3cbde8mr14088214wri.186.1652705457678; Mon, 16
 May 2022 05:50:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAAL3td0UD3Ht-rCpR5xUfmOLzeEzRSedCVXH4nTQKLR1b16+vA@mail.gmail.com>
 <6fc53990-1814-a45d-7c05-a4385246406c@kernel.dk> <CAAL3td3Em=MBPa9iJitYTAkndymzuj2DbSnbQRf=0Emsr5qHVw@mail.gmail.com>
 <744d4b58-e7df-a5fb-dfba-77fe952fe1f8@kernel.dk> <71956172-5406-0636-060d-a7c123a2bfab@kernel.dk>
 <CAAL3td2X4a9RESdSt_xFxNN3mYHBUn88cjbUH9O5wAfL86iB1Q@mail.gmail.com>
 <9c966ff9-ceb2-4fcd-ce0d-1639f2965b38@kernel.dk> <CAAL3td1dt1HJZ09OfHAce-V5js3o_DwcpyGh=8dr3F-5TQEqgg@mail.gmail.com>
In-Reply-To: <CAAL3td1dt1HJZ09OfHAce-V5js3o_DwcpyGh=8dr3F-5TQEqgg@mail.gmail.com>
From:   Constantine Gavrilov <constantine.gavrilov@gmail.com>
Date:   Mon, 16 May 2022 15:50:46 +0300
Message-ID: <CAAL3td1j-csvAo_EcOniZzu+mPR=sCLjshxYpEJOdwZU3FQmpg@mail.gmail.com>
Subject: Re: Short sends returned in IORING
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, May 15, 2022 at 4:36 PM Constantine Gavrilov
<constantine.gavrilov@gmail.com> wrote:
>
> On Thu, May 12, 2022 at 7:28 PM Jens Axboe <axboe@kernel.dk> wrote:
> >
> > On 5/11/22 8:56 AM, Constantine Gavrilov wrote:
> > > On Wed, May 4, 2022 at 6:55 PM Jens Axboe <axboe@kernel.dk> wrote:
> > >>
> > >> On 5/4/22 9:28 AM, Jens Axboe wrote:
> > >>> On 5/4/22 9:21 AM, Constantine Gavrilov wrote:
> > >>>> On Wed, May 4, 2022 at 4:54 PM Jens Axboe <axboe@kernel.dk> wrote:
> > >>>>>
> > >>>>> On 5/3/22 5:05 PM, Constantine Gavrilov wrote:
> > >>>>>> Jens:
> > >>>>>>
> > >>>>>> This is related to the previous thread "Fix MSG_WAITALL for
> > >>>>>> IORING_OP_RECV/RECVMSG".
> > >>>>>>
> > >>>>>> We have a similar issue with TCP socket sends. I see short sends
> > >>>>>> regarding of the method (I tried write, writev, send, and sendmsg
> > >>>>>> opcodes, while using MSG_WAITALL for send and sendmsg). It does not
> > >>>>>> make a difference.
> > >>>>>>
> > >>>>>> Most of the time, sends are not short, and I never saw short sends
> > >>>>>> with loopback and my app. But on real network media, I see short
> > >>>>>> sends.
> > >>>>>>
> > >>>>>> This is a real problem, since because of this it is not possible to
> > >>>>>> implement queue size of > 1 on a TCP socket, which limits the benefit
> > >>>>>> of IORING. When we have a short send, the next send in queue will
> > >>>>>> "corrupt" the stream.
> > >>>>>>
> > >>>>>> Can we have complete send before it completes, unless the socket is
> > >>>>>> disconnected?
> > >>>>>
> > >>>>> I'm guessing that this happens because we get a task_work item queued
> > >>>>> after we've processed some of the send, but not all. What kernel are you
> > >>>>> using?
> > >>>>>
> > >>>>> This:
> > >>>>>
> > >>>>> https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.19/io_uring&id=4c3c09439c08b03d9503df0ca4c7619c5842892e
> > >>>>>
> > >>>>> is queued up for 5.19, would be worth trying.
> > >>>>>
> > >>>>> --
> > >>>>> Jens Axboe
> > >>>>>
> > >>>>
> > >>>> Jens:
> > >>>>
> > >>>> Thank you for your reply.
> > >>>>
> > >>>> The kernel is 5.17.4-200.fc35.x86_64. I have looked at the patch. With
> > >>>> the solution in place, I am wondering whether it will be possible to
> > >>>> use multiple uring send IOs on the same socket. I expect that Linux
> > >>>> TCP will serialize multiple send operations on the same socket. I am
> > >>>> not sure it happens with uring (meaning that socket is blocked for
> > >>>> processing a new IO until the pending IO completes). Do I need
> > >>>> IOSQE_IO_DRAIN / IOSQE_IO_LINK for this to work? Would not be optimal
> > >>>> because of multiple different sockets in the same uring. While I
> > >>>> already have a workaround in the form of a "software" queue for
> > >>>> streaming data on TCP sockets, I would rather have kernel to do
> > >>>> "native" queueing in sockets layer, and have exrtra CPU cycles
> > >>>> available to the  application.
> > >>>
> > >>> The patch above will mess with ordering potentially. If the cause is as
> > >>> I suspect, task_work causing it to think it's signaled, then the better
> > >>> approach may indeed be to just flush that work and retry without
> > >>> re-queueing the current one. I can try a patch against 5.18 if you are
> > >>> willing and able to test?
> > >>
> > >> You can try something like this, if you run my for-5.19/io_uring branch.
> > >> I'd be curious to know if this solves the short send issue for you.
> > >>
> > >>
> > >> diff --git a/fs/io_uring.c b/fs/io_uring.c
> > >> index f6b6db216478..b835e80be1fa 100644
> > >> --- a/fs/io_uring.c
> > >> +++ b/fs/io_uring.c
> > >> @@ -5684,6 +5684,7 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
> > >>         if (flags & MSG_WAITALL)
> > >>                 min_ret = iov_iter_count(&kmsg->msg.msg_iter);
> > >>
> > >> +retry:
> > >>         ret = __sys_sendmsg_sock(sock, &kmsg->msg, flags);
> > >>
> > >>         if (ret < min_ret) {
> > >> @@ -5694,6 +5695,8 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
> > >>                 if (ret > 0 && io_net_retry(sock, flags)) {
> > >>                         sr->done_io += ret;
> > >>                         req->flags |= REQ_F_PARTIAL_IO;
> > >> +                       if (io_run_task_work())
> > >> +                               goto retry;
> > >>                         return io_setup_async_msg(req, kmsg);
> > >>                 }
> > >>                 req_set_fail(req);
> > >> @@ -5744,6 +5747,7 @@ static int io_send(struct io_kiocb *req, unsigned int issue_flags)
> > >>                 min_ret = iov_iter_count(&msg.msg_iter);
> > >>
> > >>         msg.msg_flags = flags;
> > >> +retry:
> > >>         ret = sock_sendmsg(sock, &msg);
> > >>         if (ret < min_ret) {
> > >>                 if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
> > >> @@ -5755,6 +5759,8 @@ static int io_send(struct io_kiocb *req, unsigned int issue_flags)
> > >>                         sr->buf += ret;
> > >>                         sr->done_io += ret;
> > >>                         req->flags |= REQ_F_PARTIAL_IO;
> > >> +                       if (io_run_task_work())
> > >> +                               goto retry;
> > >>                         return -EAGAIN;
> > >>                 }
> > >>                 req_set_fail(req);
> > >>
> > >> --
> > >> Jens Axboe
> > >>
> > >
> > > Jens:
> > >
> > > I was able to test the first change on the top of Linus kernel git
> > > (5.18.0-rc6).
> > >
> > > I do not get short sends anymore, but I get corruption in  sent
> > > packets (corruption is detected by the receiver). It looks like short
> > > sends handled by the patch intermix data from multiple send SQEs in
> > > the stream, so ordering of multiple SQEs in URING becomes broken.
> >
> > Unless you specifically ask for ordering (eg using IOSQE_IO_LINK), then
> > there is no guaranteed ordering for sends. So it's quite possible to end
> > up with the scenario you describe, where you end up with interleaved
> > data from two requests if they are not able to send out all their data
> > in one go (eg running out of space).
> >
> >
> > --
> > Jens Axboe
> >
>
> Jens:
>
> I have looked at the kernel sockets code and uring io_sendmsg() implementation.
>
> The URING will call __sys_sendmsg_sock() which is the same code path
> as Linux blocking system call for sendmsg() API.
>
> This will eventually call inet6_sendmsg() / inet_sendmsg() (after
> copying the buffers and doing the checks), and for the tcp case , both
> functions will directly call tcp_sendmsg(). The call tcp_sendmsg() has
> internal locking inside:
>
> int tcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
> {
> int ret;
>
> lock_sock(sk);
> ret = tcp_sendmsg_locked(sk, msg, size);
> release_sock(sk);
>
> return ret;
> }
>
> This means multiple sends on the sockets are protected, until the code
> returns. The real problem is that tcp_sendmsg_locked() currently does
> nothing with the MSG_WAITALL flag, and partial sends can be returned.
> If my memory serves me right, the flag was honored before, but was
> removed later as a Linux only extension for sendmsg().
>
> While we can replicate __sys_sendmsg_sock() behavior of validating the
> arguments and copying the user-space buffers, and then lock socket and
> call sock->ops->sendmsg_locked() and handle the partial sends inside,
> I feel it is duplicating existing kernel code. I can provide this
> implementation, but I doubt it will ever be accepted.
>
> The real fix (if people want this feature) is adding support for
> MSG_WAITALL to tcp_sendmsg_locked(). Then the uring does not need to
> do anything else.
>
> Another thing is that tcp_sendmsg_locked() will wait for buffers using
> timeout returned by sock_sndtimeo(sk, flags & MSG_DONTWAIT), so
> modifying the send timeout may be a good option, but I have not
> investigating if there are internal limitations on setting the timeout
> or using it in sk_stream_wait_memory(sk, &timeo). I will try setting
> the large send timeout and perhaps patching tcp_sendmsg() to not do an
> early return if sk_stream_wait_memory(sk, &timeo) returns an error and
> MSG_WAITALL flag was set.
>
> Jens, what are your thoughts on this? It does not seem that your patch
> for 5.19 for sendmsg() follows the sendmsg() current behavior, and
> retrying sends on a non-locked socket is not correct. If fix anything
> (and I believe we need the fix), we need to fix it in tcp_sendmsg().
>
> Other issues with muti-queue TCP sends are:
> 1. Ordering between individual CQEs (when the use the same socket
> operation). I hope URING preserves the order of SQE processing?
> 2. I see that there is no asynchronous interface on socket sends (not
> sure how Linux async IO handles it). This means that since we are
> using blocking IO send operations, operations on one socket will block
> operations on others. This is not ideal.

Jens:

I have further looked at io_uring.c and saw the async IO queue, and
async IO retries.

I have tried the following kernel patch (against master tree):

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index cf18fbcbf123..6ca8c286d27f 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1408,9 +1408,13 @@ int tcp_sendmsg_locked(struct sock *sk, struct
msghdr *msg, size_t size)
             tcp_push(sk, flags & ~MSG_MORE, mss_now,
                  TCP_NAGLE_PUSH, size_goal);

-        err = sk_stream_wait_memory(sk, &timeo);
-        if (err != 0)
-            goto do_error;
+        if (flags & MSG_WAITALL)
+            timeo = -1U;
+        while ((err = sk_stream_wait_memory(sk, &timeo))) {
+            if (err != -EAGAIN || ! (flags & MSG_WAITALL))
+                goto do_error;
+            timeo = -1U;
+        }

         mss_now = tcp_send_mss(sk, &size_goal, flags);
     }

After this patch, I observe the following results:
1. My TCP queue (send queue depth 1 on each socket) + MSG_WAITALL
flag. I see disconnects induced by TCP stack, when working with
several sockets, even if the thread is single.
2. My TCP queue (send queue depth 1 one each socket), no MSG_WAITALL
flag. Works correctly for single and multiple threads, with multiple
sockets per thread (as without the patch).
3. My TCP queue (send queue depth 1 on each socket) + MSG_WAITALL flag
+ IOSQE_ASYNC flag on all sends. No issues with single or multiple
threads, with multiple  sockets per thread.
4. No special TCP queue (send queue depth >1 on each socket) +
MSG_WAITALL flag. No short sends, but data corruption detected by the
application, even with a single socket and single thread. This is with
and without IOSQE_ASYNC flag.

Frankly, I do not understand this. Perhaps there is an issue with
URING sync+async retry flow. But there is more than that. When doing
async IO, I see data corruption. Looking at the tcp_sendmsg, I think
it locks for the duration of send, and my patch just waits for the
space. To me, it looks like IOV is perhaps copied to some shared place
not protected by the lock, but I do not see it from the socket or
URING code.

Amy thoughts? (I do understand that my packets in the SQE can be
reordered, because the IO async queue is multi-threaded, and I
actually see it from the tcpdump. I just do not understand why the
data stream becomes corrupt).


-- 
----------------------------------------
Constantine Gavrilov
Storage Architect
Master Inventor
Tel-Aviv IBM Storage Lab
1 Azrieli Center, Tel-Aviv
----------------------------------------
