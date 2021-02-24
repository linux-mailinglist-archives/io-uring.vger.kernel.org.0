Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F453239C9
	for <lists+io-uring@lfdr.de>; Wed, 24 Feb 2021 10:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234721AbhBXJqC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Feb 2021 04:46:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234637AbhBXJoB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Feb 2021 04:44:01 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3EA9C061574
        for <io-uring@vger.kernel.org>; Wed, 24 Feb 2021 01:43:20 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id d11so1211510wrj.7
        for <io-uring@vger.kernel.org>; Wed, 24 Feb 2021 01:43:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ty66YqZp+gtZ8i5nVM6d2AoDFVjMiOdrp/eVCSvMB/M=;
        b=piUYbYgLFo/EXKxF2oOD6bWehal7xPh4krJWu1JTNsRPTltvUPYssaI9ww/o/CmWZJ
         7U03cqReuimuohuMOESjB/8PnyA7XBaQ5yUMMSYEjIAarNx/fF75GxJmw4eMGKQSL3F1
         8wo31QuUrivKP8WnQQKs2gXRk2/8PKe2GjPhuek0GIR6XW1Ov2xs8dFeieYKDLZ7nMP5
         rKy5gdr1Mljlneo03f/garJ/d01kA836hRerdSvgoRVseMTz3V9YIJP2eYsZ1mchSmpJ
         I7mMhpLspfIpmzbXwBMFqSJ81PL21XL2MoErIJ+oTOdtdhTFIRrQ+kSBDJTiejNiKZsR
         NHXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ty66YqZp+gtZ8i5nVM6d2AoDFVjMiOdrp/eVCSvMB/M=;
        b=dtygVtnu2Pi1FD134W+3eiiZibcuFdB49YPfDVBavbI4mVpvwigeXVJjigSJBoaKuW
         DnTbtLiqqjX3tOtbxQ3jPc73JjgZOA3EeJ6CaBS4ZEwttzrh91r+fAX89OXyUpR4ZuVO
         1rNO6TksP7ckHuuwn2l6cKeEQGEHDoyHxdPtYCZiMFFLiXyFQAlr1Kw26wDAAkKAmMRe
         2ey1XrkTh1FX3QSc/lf4y4xKCSTva9gMcdCm5oR3mD1q3b7wJLwY12vF7HJPeXmNgD4I
         UTIRgf9ZsvY49+fIUHThWuSnZQ3Bij3jniETQRImH7XV/+MYP0RC7yMgYy45ujDgo5ko
         8YqQ==
X-Gm-Message-State: AOAM531Gtd+rq2FheglRSuDiebfSSdqdIC5DW5Ch0NXoUBF6BAFaIVw5
        54Wgtkq5jtqYwck0sprQruMOpKus3Gqivg==
X-Google-Smtp-Source: ABdhPJzQXeoUQX4UVdPbclksPP8mdqITHdX+5KiA40JdlV7OhSCP2tPpqi+o2NkCOZxVRubACY+cJQ==
X-Received: by 2002:adf:fe01:: with SMTP id n1mr5888522wrr.341.1614159799018;
        Wed, 24 Feb 2021 01:43:19 -0800 (PST)
Received: from [192.168.8.165] ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id p17sm1824487wmq.27.2021.02.24.01.43.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Feb 2021 01:43:18 -0800 (PST)
Subject: Re: [PATCH v2 1/1] io_uring: allocate memory for overflowed CQEs
To:     Jens Axboe <axboe@kernel.dk>, Hao Xu <haoxu@linux.alibaba.com>,
        io-uring@vger.kernel.org
References: <a5e833abf8f7a55a38337e5c099f7d0f0aa8746d.1614083504.git.asml.silence@gmail.com>
 <f57545fb-a109-0881-ff14-f371d1a9d811@linux.alibaba.com>
 <fda005e8-d16d-6563-d526-440deb7737f6@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <055b8a19-c86a-88a5-79f4-21099bba6f14@gmail.com>
Date:   Wed, 24 Feb 2021 09:39:27 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <fda005e8-d16d-6563-d526-440deb7737f6@kernel.dk>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 24/02/2021 03:18, Jens Axboe wrote:
> On 2/23/21 8:06 PM, Hao Xu wrote:
>> ÔÚ 2021/2/23 ÏÂÎç8:40, Pavel Begunkov Ð´µÀ:
>>> Instead of using a request itself for overflowed CQE stashing, allocate
>>> a separate entry. The disadvantage is that the allocation may fail and
>>> it will be accounted as lost (see rings->cq_overflow), so we lose
>>> reliability in case of memory pressure. However, it opens a way for for
>>> multiple CQEs per an SQE and even generating SQE-less CQEs >
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>> Hi Pavel,
>> Allow me to ask a stupid question, why do we need to support multiple 
>> CQEs per SQE or even SQE-less CQEs in the future?
> 
> Not a stupid question at all, since it's not something we've done
> before. There's been discussion about this in the past, in the presence
> of the zero copy IO where we ideally want to post two CQEs for an SQE.
> Most recently I've been playing with multishot poll support, where a
> POLL_ADD will stay active after triggering. Hence you could be posting
> many CQEs for that SQE, over the life time of the request.

Yep, in addition should be useful for eBPF requests.

-- 
Pavel Begunkov
