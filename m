Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618E1305164
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 05:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239535AbhA0Ep3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jan 2021 23:45:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbhA0DAh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jan 2021 22:00:37 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87DD7C0612F2
        for <io-uring@vger.kernel.org>; Tue, 26 Jan 2021 18:40:51 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id g15so418699pjd.2
        for <io-uring@vger.kernel.org>; Tue, 26 Jan 2021 18:40:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=iJguxBN5iYdMC3W7MjV/lpnyzNfWLl0Nf64muYvF+Pw=;
        b=wlt1E6KbIkmcikJjCs+RduQqfwSGsECE3+xA4Ifymo7XuGg3h6WCo4OtWlhB2Et5jx
         LYfwLnBbkN4VHAaOmJjc9aC9kmMe3vybJKW/81ple/0XeTiwA0x54cG4krHeFnoWJWWS
         EBA+COd4mybCYVBGnqJb+SOg78bA+9y6U5asi9Mi0TG32dHal3MrD3IyIJMGTmNbjtge
         yKSrcoJW/MeIU6YpSZrTEQiZv1tizB6kC865KnFKHCe0JZWCN2ahgkMeu6yr4mipdmc3
         ok6Mh2Si833W+ZIf5RCZ99Y6Pv0gCZs+QFUY7ZaFvozjeQiVkmZ+JdmeK2fZLZWca65g
         LCmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iJguxBN5iYdMC3W7MjV/lpnyzNfWLl0Nf64muYvF+Pw=;
        b=rPgHMLSYu+5jM3znvyrBkxvAeM0pGO2+aT8md579Tc5pCiaGT+BEGVAimrX2xrxplk
         z3CA5/V5IjmiCH2EAN22hhUf0LCwuf59u2lnmf085trbPwukNh4g1lvd1YA50Z110XE5
         sbDeDVM4KoedaaNkMIJ+RGRfeP/n0j/CnEZVGANuz97+WhgsvAHhATa4Ay+hEiyb1/w0
         B5Nn3PHKC36o7Fen7eEAxhE4vOmGUTjSFDzKvJ0r937mPgUQnFEtYlLUKGgF1Hl+xThM
         JlL1FQxTLDgv0c7db2yNPE0w4LNzo0eu32l2rlIqBkvFVngrJ3/6QXzfUuNKLXX+0vF1
         M4EA==
X-Gm-Message-State: AOAM532CurNTkJ7CKQIPNfe30h6MrUsb3GUxBP2afcFN1N5Mq8YSUI4e
        bKHyEpstjnC4pVZKs/nf/yiyWDoG55Ir4g==
X-Google-Smtp-Source: ABdhPJyUKmwjCtak5qbg/x9iIxqRlwSIMW7obfhw3xerbn6hK2NDJ/emM80cZ98JoNhv1/lfx+oArw==
X-Received: by 2002:a17:902:8342:b029:e1:6aa:d770 with SMTP id z2-20020a1709028342b02900e106aad770mr902271pln.27.1611715250415;
        Tue, 26 Jan 2021 18:40:50 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id x3sm404492pfp.98.2021.01.26.18.40.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 18:40:49 -0800 (PST)
Subject: Re: [PATCH 5.11] io_uring: fix wqe->lock/completion_lock deadlock
To:     Joseph Qi <joseph.qi@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
References: <9c4f7eb623ae774f3f17afbc1702749480ee19be.1611703952.git.asml.silence@gmail.com>
 <9c4e03b0-b506-efb6-7ecf-cf290780de6d@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <00c631ac-360a-aae4-14af-5c43691ab5f6@kernel.dk>
Date:   Tue, 26 Jan 2021 19:40:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <9c4e03b0-b506-efb6-7ecf-cf290780de6d@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/26/21 6:52 PM, Joseph Qi wrote:
> 
> 
> On 1/27/21 7:35 AM, Pavel Begunkov wrote:
>> Joseph reports following deadlock:
>>
>> CPU0:
>> ...
>> io_kill_linked_timeout  // &ctx->completion_lock
>> io_commit_cqring
>> __io_queue_deferred
>> __io_queue_async_work
>> io_wq_enqueue
>> io_wqe_enqueue  // &wqe->lock
>>
>> CPU1:
>> ...
>> __io_uring_files_cancel
>> io_wq_cancel_cb
>> io_wqe_cancel_pending_work  // &wqe->lock
>> io_cancel_task_cb  // &ctx->completion_lock
>>
>> Only __io_queue_deferred() calls queue_async_work() while holding
>> ctx->completion_lock, enqueue drained requests via io_req_task_queue()
>> instead.
>>
> We should follow &wqe->lock > &ctx->completion_lock from now on, right?
> I was thinking getting completion_lock first before:(
> 
> Moreover, there are so many locks and no suggested locking order in
> comments, so that it is hard for us to participate in the work.

So many locks? There's really not even a handful, and only a few that
have overlaps (and hence ordering). Other sub-systems are have a crap
ton more :-). But I can document the ordering, at least that's a start
even if things like that tend to go stale. 

Thanks for reporting and testing! I'll queue this up for 5.11.

-- 
Jens Axboe

