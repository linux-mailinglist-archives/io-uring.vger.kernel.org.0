Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 014A83CE818
	for <lists+io-uring@lfdr.de>; Mon, 19 Jul 2021 19:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348634AbhGSQpz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Jul 2021 12:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352016AbhGSQnI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Jul 2021 12:43:08 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F59C04DF11
        for <io-uring@vger.kernel.org>; Mon, 19 Jul 2021 09:53:59 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id me13-20020a17090b17cdb0290173bac8b9c9so14541937pjb.3
        for <io-uring@vger.kernel.org>; Mon, 19 Jul 2021 10:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=bC4MxiMR6/WdBb2kDanGoPVgU3HczlOrNCuENL6GncA=;
        b=hmXqMxM2ozNMJ1yd6YypN9dBzCd+cMV0TLASzlrgrOGE4S1FEdB1xHLRbxl80iZ3S+
         3B3IQb9oULtT+YvHvVJVD6DKYWYiyWhbeMTe9mtTJPSd01e/MaWGfFOXjt1aR923HG7M
         AS/rTwsj8xdw/09zpeklv9sBOXOgjtGtp5rFttSqWEMMrXGgwTajHwdgSUZhjZ+ua5RD
         56RF3cF2YZrSuKSfeogJKeljBmIg7FYgVAcKY4ZRXtAiPHBM5gENsJhBKrAe9LVLj+hZ
         QYVJ3dEly0d75TEjNJkv4knWAfaYVClm/4HObWFpbq3sDC77xh3k5tJJtULb5YIWdU6A
         mb/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bC4MxiMR6/WdBb2kDanGoPVgU3HczlOrNCuENL6GncA=;
        b=IH/rp6Qw3+WIcf1isJ+7sx3zyH+R2c94tRc/Hy2GCj62QtbgQ8gr0Dy5yAuc2M/H1p
         B3F24N/xFUD3LuyIvfdVPej1vy00sFU3rET/C9Rsmstq88JdROpSOvidfs9gN1NW7H23
         F11XTzT7+d/ySwUOnyvehvtYpJmFIzrGOV36UBQ2iD2OGQxWTk2q6Btd9uKfC/JZHoYe
         1G/KqoNxupLB7bo8DEVJZS2ecvvilM+ioum7oMLdfnlQtBFdAablO2H13J458g6mjzif
         loezrEC6EWelGnLb8t3m9BX7QrfLTOWs5Vn31IMOkj3O886SjkRYPbVHNvh55ZaVZG//
         c1bQ==
X-Gm-Message-State: AOAM530xCafQ6OluECunNE5ZoapEilJijwl1mCUTx+TZE5rAyIEa74Cy
        SSdAe8IksiZxTGWOFlJe3ohCfQ==
X-Google-Smtp-Source: ABdhPJxrccFJArRJU0ZXgLL/h/RwE28t4EJt19cXfFm/Ig+3ToipoP+kD+6due42KvX9Vhs+AQuGTg==
X-Received: by 2002:a17:90a:c506:: with SMTP id k6mr31496920pjt.198.1626714833812;
        Mon, 19 Jul 2021 10:13:53 -0700 (PDT)
Received: from [192.168.1.187] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id k5sm21279333pfu.142.2021.07.19.10.13.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jul 2021 10:13:53 -0700 (PDT)
Subject: Re: [syzbot] INFO: task hung in io_sq_thread_park (2)
To:     Pavel Begunkov <asml.silence@gmail.com>,
        syzbot <syzbot+ac957324022b7132accf@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, mingo@redhat.com, peterz@infradead.org,
        rostedt@goodmis.org, syzkaller-bugs@googlegroups.com,
        will@kernel.org
References: <000000000000e1f38205c73b72cc@google.com>
 <c57f80f7-440b-9f12-a7b7-a58ed7ab400a@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3ff29943-0f93-1381-1c8a-46f80aecd0b4@kernel.dk>
Date:   Mon, 19 Jul 2021 11:13:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c57f80f7-440b-9f12-a7b7-a58ed7ab400a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/19/21 10:57 AM, Pavel Begunkov wrote:
> On 7/16/21 11:57 AM, syzbot wrote:
>> Hello,
>>
>> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
>> WARNING in io_uring_cancel_generic
> 
> __arm_poll doesn't remove a second poll entry in case of failed
> __io_queue_proc(), it's most likely the cause here.
> 
> #syz test: https://github.com/isilence/linux.git syztest_sqpoll_hang

Was my thought on seeing the last debug run too. Haven't written a test
case, but my initial thought was catching this at the time that double
poll is armed, in __io_queue_proc(). Totally untested, just tossing
it out there.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0cac361bf6b8..ed33de5fffd2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5002,6 +5002,9 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 	if (unlikely(poll->head)) {
 		struct io_poll_iocb *poll_one = poll;
 
+		/* first poll failed, don't arm double poll */
+		if (pt->error)
+			return;
 		/* already have a 2nd entry, fail a third attempt */
 		if (*poll_ptr) {
 			pt->error = -EINVAL;

-- 
Jens Axboe

