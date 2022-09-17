Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E12F15BB7E3
	for <lists+io-uring@lfdr.de>; Sat, 17 Sep 2022 12:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiIQKof (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 17 Sep 2022 06:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiIQKoe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 17 Sep 2022 06:44:34 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0033C1032
        for <io-uring@vger.kernel.org>; Sat, 17 Sep 2022 03:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:To:Date:Message-ID:CC;
        bh=cr799X4Nfwg6jaSUGjuuOY+biCEnu3idyoxdxFW5pgI=; b=STgYE/672DqJ2kA9aI44uPFWgk
        JZvJKotVvljZaaijh0RUK6js6YvOoW6EKQHoRie1yT6ujxx4qXiPuctpika7ySwNVjSyvxrfTypK7
        S6XIfuJZZze/TB8w4Iaszk3oAio8rZasPA9J/OyCzUolN9z3KtuNAYmIDyOqh2Ac5zcOV6+jwjs+H
        6XJJkTI23Mj1t09Nrzj+i4L2hMrdCPxpOPJknzb0vA305lho3+LvbNVZxHrPRShk+/zEy/Y1BwLGC
        b4MZJvCVV/SD8nki6WY9oiuCRkbtYptw58KMAR2x4pkeMMZVBA2NI43PVsiz8pwZvQRF6yyG0TUyS
        ok7GSN3LJpaFouRSvaMVCC9z110oLo5cfDPQyjQ3J4cd4qL5uKvcOg5W2qyYmENdr6QfWN2xxQk3J
        E6UX+hdoMgAMXtvHtmb5np3+AVCP6Eh3Fxmf4zasj8WV0vJUfwrEFGgneqPgoPTAZlni1g2z6UKwL
        txCKWui/4QhDc837bnTXIRXX;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oZVJF-000nz9-Fv; Sat, 17 Sep 2022 10:44:29 +0000
Message-ID: <a5e2e475-3e81-4375-897d-172c4711e3d1@samba.org>
Date:   Sat, 17 Sep 2022 12:44:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        axboe@kernel.dk
References: <cover.1663363798.git.metze@samba.org>
 <734a8945-3668-5aa8-df8a-a858213e73ed@gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH for-6.0 0/5] IORING_OP_SEND_ZC improvements
In-Reply-To: <734a8945-3668-5aa8-df8a-a858213e73ed@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Am 17.09.22 um 11:16 schrieb Pavel Begunkov:
> On 9/16/22 22:36, Stefan Metzmacher wrote:
>> Hi Pavel, hi Jens,
>>
>> I did some initial testing with IORING_OP_SEND_ZC.
>> While reading the code I think I found a race that
>> can lead to IORING_CQE_F_MORE being missing even if
>> the net layer got references.
> 
> Hey Stefan,
> 
> Did you see some kind of buggy behaviour in userspace?

No I was just reading the code and found it a bit confusing,
and couldn't prove that we don't have a problem with loosing
a notif cqe.

> If network sends anything it should return how many bytes
> it queued for sending, otherwise there would be duplicated
> packets / data on the other endpoint in userspace, and I
> don't think any driver / lower layer would keep memory
> after returning an error.

As I'm also working on a socket driver for smbdirect,
I already thought about how I could hook into
IORING_OP_SEND[MSG]_ZC, and for sendmsg I'd have
a loop sending individual fragments, which have a reference,
but if I find a connection drop after the first one, I'd
return ECONNRESET or EPIPE in order to get faster recovery
instead of announcing a short write to the caller.

If we would take my 5/5 we could also have a different
strategy to check decide if MORE/NOTIF is needed.
If notif->cqe.res is still 0 and io_notif_flush drops
the last reference we could go without MORE/NOTIF at all.
In all other cases we'd either set MORE/NOTIF at the end
of io_sendzc of in the fail hook.

> In any case, I was looking on a bit different problem, but
> it should look much cleaner using the same approach, see
> branch [1], and patch [3] for sendzc in particular.
> 
> [1] https://github.com/isilence/linux.git partial-fail
> [2] https://github.com/isilence/linux/tree/io_uring/partial-fail
> [3] https://github.com/isilence/linux/commit/acb4f9bf869e1c2542849e11d992a63d95f2b894

	const struct io_op_def *def = &io_op_defs[req->opcode];

	req_set_fail(req);
	io_req_set_res(req, res, io_put_kbuf(req, IO_URING_F_UNLOCKED));
	if (def->fail)
		def->fail(req);
	io_req_complete_post(req);

Will loose req->cqe.flags, but the fail hook in general looks like a good idea.

And don't we care about the other failure cases where req->cqe.flags gets overwritten?

metze
