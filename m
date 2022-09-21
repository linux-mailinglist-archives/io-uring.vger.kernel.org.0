Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0E45BFDA4
	for <lists+io-uring@lfdr.de>; Wed, 21 Sep 2022 14:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiIUMSZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Sep 2022 08:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiIUMSY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Sep 2022 08:18:24 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB71BF46
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 05:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:To:Date:Message-ID:CC;
        bh=3r4Fm0DhUFlP+7VWCjVpIn92BJwsEt2FIEy0Rz14G2k=; b=soGMGWGNMDmolaHEZ3NSrVbZjw
        TDSvKZiTVSOqF+iKifv9sN8CJWxh+atB4c2pdJBuwuZ5onhfcCmRPMS/beS3I//tW+sk3MP6Tlxb+
        l0KO20yoroqdg3JcYF3f2hOeYsa3qYjtZTaSUsAx+8/p+/dAGSQOQlSJs5kLWQAPhNwAqzOAMZ3LH
        iKIWEW01kI6+4O+i+JhFOXwTAxiSsgeLwg2YeqYwWu4hwdBpGHsv5QU99MTIix5Ycn5QKA8FtrB50
        QpdNAZHTO9ovoCmZy5O3uCK9hzESQxQW3JM9eJVSocf1xniIVz5gYqRoLr8QgHlrVm/f5nCCUlb18
        +JSa08ts0aFsyP+cgIPjnYhWPK+JeqdRonrCNslq/xVp8oEGTidnf0UBXr3uu3OpR486RV3rl3Lgq
        ezT+2E6THSknThzgaRgwJWILBeFtWHif+oAGnqLLhozzfxWX6/tq5mrIjDq6yQY+tvYGFTH7YLNRZ
        oX+Y9ljK4e0bwi4pKCr9Nd/n;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oaygG-001LU8-JB; Wed, 21 Sep 2022 12:18:20 +0000
Message-ID: <4b84da78-0ff9-5b29-907c-2f8a392baf80@samba.org>
Date:   Wed, 21 Sep 2022 14:18:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        axboe@kernel.dk
References: <cover.1663363798.git.metze@samba.org>
 <734a8945-3668-5aa8-df8a-a858213e73ed@gmail.com>
 <a5e2e475-3e81-4375-897d-172c4711e3d1@samba.org>
 <8b456f19-f209-a83e-a346-ff8ea7f190ac@gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH for-6.0 0/5] IORING_OP_SEND_ZC improvements
In-Reply-To: <8b456f19-f209-a83e-a346-ff8ea7f190ac@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Hi Pavel,

>>> If network sends anything it should return how many bytes
>>> it queued for sending, otherwise there would be duplicated
>>> packets / data on the other endpoint in userspace, and I
>>> don't think any driver / lower layer would keep memory
>>> after returning an error.
>>
>> As I'm also working on a socket driver for smbdirect,
>> I already thought about how I could hook into
>> IORING_OP_SEND[MSG]_ZC, and for sendmsg I'd have
>> a loop sending individual fragments, which have a reference,
>> but if I find a connection drop after the first one, I'd
>> return ECONNRESET or EPIPE in order to get faster recovery
>> instead of announcing a short write to the caller.
> 
> I doesn't sound right for me, but neither I know samba to
> really have an opinion. In any case, I see how it may be
> more robust if we always try to push a notification cqe.
> Will you send a patch?

You mean the IORING_OP_SEND_ZC should always
issue a NOTIF cqe, one it passed the io_sendzc_prep stage?

>> If we would take my 5/5 we could also have a different
>> strategy to check decide if MORE/NOTIF is needed.
>> If notif->cqe.res is still 0 and io_notif_flush drops
>> the last reference we could go without MORE/NOTIF at all.
>> In all other cases we'd either set MORE/NOTIF at the end
>> of io_sendzc of in the fail hook.
> 
> I had a similar optimisation, i.e. when io_notif_flush() in
> the submission path is dropping the last ref, but killed it
> as it was completely useless, I haven't hit this path even
> once even with UDP, not to mention TCP.

If I remember correctly I hit it all the time on loopback,
but I'd have to recheck.

>>> In any case, I was looking on a bit different problem, but
>>> it should look much cleaner using the same approach, see
>>> branch [1], and patch [3] for sendzc in particular.
>>>
>>> [1] https://github.com/isilence/linux.git partial-fail
>>> [2] https://github.com/isilence/linux/tree/io_uring/partial-fail
>>> [3] https://github.com/isilence/linux/commit/acb4f9bf869e1c2542849e11d992a63d95f2b894
>>
>>      const struct io_op_def *def = &io_op_defs[req->opcode];
>>
>>      req_set_fail(req);
>>      io_req_set_res(req, res, io_put_kbuf(req, IO_URING_F_UNLOCKED));
>>      if (def->fail)
>>          def->fail(req);
>>      io_req_complete_post(req);
>>
>> Will loose req->cqe.flags, but the fail hook in general looks like a good idea.
> 
> I just don't like those sporadic changes all across core io_uring
> code also adding some overhead.
> 
>> And don't we care about the other failure cases where req->cqe.flags gets overwritten?
> 
> We don't usually carry them around ->issue handler boundaries,
> e.g. directly do io_post_aux_cqe(res, IORING_CQE_F_MORE);
> 
> IORING_CQE_F_BUFFER is a bit more trickier, but there is
> special handling for this one and it wouldn't fit "set cflags
> in advance" logic anyway.
> 
> iow, ->fail callback sounds good enough for now, we'll change
> it later if needed.

The fail hook should re-add the MORE flag?

So I'll try to do the following changes:

1. take your ->fail() patches

2. once io_sendzc_prep() is over always trigger MORE/NOFIF cqes
    (But the documentation should still make it clear that
     userspace have to cope with just a single cqe (without MORE)
     for both successs and failure, so that we can improve things later)

3. Can I change the cqe.res of the NOTIF cqe to be 0xffffffff ?
    That would indicate to userspace that we don't give any information
    if zero copy was actually used or not. This would present someone
    from relying on cqe.res == 0 and we can improve it by providing
    more useful values in future.

Are you ok with that plan for 6.0?

metze
