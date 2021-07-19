Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16DF13CE985
	for <lists+io-uring@lfdr.de>; Mon, 19 Jul 2021 19:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351796AbhGSQ5Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Jul 2021 12:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358549AbhGSQxP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Jul 2021 12:53:15 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077A9C0A8878;
        Mon, 19 Jul 2021 10:10:23 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id g16so23011472wrw.5;
        Mon, 19 Jul 2021 10:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=SspOufy8IxePVa2SqHnpK2fSzNtm7ELeqTvtgBfDdaI=;
        b=Mznpbm+pHfyK6OsXSEIdTTal9vHlqbcv/Bg/FMSn4v2kzcLb1IdGpGaGf11XIM49Pn
         YCC57yySK942BiE4xahv6Naw15yAszkPpe3+uPk+bGs/bzXjyd/16PlVepy4BlfMlcJs
         K+Z7Ldfj0rE3u8YhgtxAwcS49J6hjpvC6nKQHWOlsykOxuGV6Ftg5k/EeGE5LfBTrxZN
         3pBTb5qbdBn2lhfAhwvPx45dyloziTzw/XXxsodSVLdUSmbAe9BdKSl3A5t9P2b/KG6Q
         ArK/G3RZkRVo3OzIGr9eLidXjlrYXOHcsCMZiBGDHofpCgGar26lE8TyWNWWC1XpbRZO
         h4CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SspOufy8IxePVa2SqHnpK2fSzNtm7ELeqTvtgBfDdaI=;
        b=S16Qrw5gQCfYzrGbfCscKY/fCKWXnWxErs1pWWdkQXyLVAonhmBKLRDU/cyPjfUP+k
         52HYc1CcdX3hRbkriiff0HAigFDPVI8bL8E3I+9xCIa3XwtPhCutSzxSDXQtKbBKFsBI
         UIGj+HAL+RiPNn6/NNSsnISVgdWjRQauRoRsnIcD0qqqDMw0JNHxtgygcGaGAafd+a2w
         L0awVpMKODqXdjrj/yqx4eilMVjHvE2ollp8xtbBOQBz8fLBTzPMGLSQ/+wol3VNjwff
         ClNEq5S6uN+iHvpO+K1JS0gOKPVRY/AyNh+NGM3ZmTp/iSVLSDfEpHOMpEkKh5unXyNf
         2lHw==
X-Gm-Message-State: AOAM5311QUf+6NbZCoXFbmOOy0F8LIZ+bGzWtY8gQQnnGREX3SHqi+n9
        /hrt7yE5IL07hXrvNjTul2M=
X-Google-Smtp-Source: ABdhPJwkN43JzRKrh+BMwp0S+4awvcgTmrnnz61Jxi1T51tdU9Bc2r8sSRzqm9E0G4VxPuCoRO3r9g==
X-Received: by 2002:a5d:5692:: with SMTP id f18mr30195074wrv.135.1626715740867;
        Mon, 19 Jul 2021 10:29:00 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.204])
        by smtp.gmail.com with ESMTPSA id l14sm20057228wrs.22.2021.07.19.10.28.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jul 2021 10:29:00 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>,
        syzbot <syzbot+ac957324022b7132accf@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, mingo@redhat.com, peterz@infradead.org,
        rostedt@goodmis.org, syzkaller-bugs@googlegroups.com,
        will@kernel.org
References: <000000000000e1f38205c73b72cc@google.com>
 <c57f80f7-440b-9f12-a7b7-a58ed7ab400a@gmail.com>
 <3ff29943-0f93-1381-1c8a-46f80aecd0b4@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [syzbot] INFO: task hung in io_sq_thread_park (2)
Message-ID: <b48f3e01-c07d-56ac-3624-afc74ef08acd@gmail.com>
Date:   Mon, 19 Jul 2021 18:28:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <3ff29943-0f93-1381-1c8a-46f80aecd0b4@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/19/21 6:13 PM, Jens Axboe wrote:
> On 7/19/21 10:57 AM, Pavel Begunkov wrote:
>> On 7/16/21 11:57 AM, syzbot wrote:
>>> Hello,
>>>
>>> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
>>> WARNING in io_uring_cancel_generic
>>
>> __arm_poll doesn't remove a second poll entry in case of failed
>> __io_queue_proc(), it's most likely the cause here.
>>
>> #syz test: https://github.com/isilence/linux.git syztest_sqpoll_hang
> 
> Was my thought on seeing the last debug run too. Haven't written a test
> case, but my initial thought was catching this at the time that double
> poll is armed, in __io_queue_proc(). Totally untested, just tossing
> it out there.

Wouldn't help, unfortunately, the way syz triggers it is making a
request to go through __io_queue_proc() three times.

Either it's 3 waitqueues or we need to extend the check below to
the double poll entry.

if (poll_one->head == head)
	return;

> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 0cac361bf6b8..ed33de5fffd2 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5002,6 +5002,9 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
>  	if (unlikely(poll->head)) {
>  		struct io_poll_iocb *poll_one = poll;
>  
> +		/* first poll failed, don't arm double poll */
> +		if (pt->error)
> +			return;
>  		/* already have a 2nd entry, fail a third attempt */
>  		if (*poll_ptr) {
>  			pt->error = -EINVAL;
> 

-- 
Pavel Begunkov
