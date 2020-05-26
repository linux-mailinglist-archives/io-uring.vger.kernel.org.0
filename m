Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10FE1E2583
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2020 17:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728166AbgEZPdK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 11:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727898AbgEZPdK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 11:33:10 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF814C03E96D
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 08:33:09 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id e2so24244825eje.13
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 08:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1fVaeV+qbLUAnmTmBD5NO/dhAyN8oukqXWEuVYz9RZs=;
        b=Jn5bLu33wQug0cAUOkCjvn909AdpEyBM4QX7UAcvdH3wXmG9WO6vskb1PFPNJzq27K
         tulhcgrelaTzPT4mxPwfts43RaQCftkKObVM3rlgjJsPBzR/6t9Axyi8NCyI1NmE32U6
         QgLw2KXYYTW+zosLIqBeU6TgMOU/EUhyFliywsF3dJNaS65wIzlpDMfsmJRCGvvFOqy+
         VcXSey2S2auB4YM0AuDUClYBflkVKfI84HePwjkHnsIXUp0MhYi2LjgaM0fT7s31m7bS
         ch7r0x2ugZmYO+saOn0ISrfGRBwO5AbZdq+Fxrq9bxk1+M4JzvByIM90d7z04WyNZ4oj
         nq8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=1fVaeV+qbLUAnmTmBD5NO/dhAyN8oukqXWEuVYz9RZs=;
        b=Du2dXIg5ypi1llveElVRSygK1OqDE35+rxiCMVEzUBCCA4n/82v9dsxV5Gl/k51F5U
         T5VFo+UojyiQJgBw2qSP7212zkgjuC2oD9Et+BSDlCXQDo/cD6Eq/VS44Ccdy7mD51s2
         q180VD/TsSaj1qCiQg/BeZrexPpD6woj4kSze8PqEYgGBKI2rkXfmBch+5cLn82Uj6Nz
         fQnCKiK5r242cgFdWPjFg7dYvRdWniI263Y9ynsptqXfEU0V0T1qAUVQOs5tip+hpuaV
         tTpqjCYrNDhSCr34TxHEUWzCLgxDJLjNukdTOfWnqZ8TDsaWNCT6lqR/XkUXnoG5IUt/
         ls0A==
X-Gm-Message-State: AOAM533BP8UuWhKj0ex4fzRuiPK9v2+GWf9h9KGiw7dz+ky/kKPt2UBI
        UT6Bzm8tBt/zoCLhidIPh60mFd2j
X-Google-Smtp-Source: ABdhPJy3ZcYLVXks0jrVR1a6TOkJFpS37z1eLUtEfSHlCKbC9L9ctPHqrbj6OauNbwEaBvWVYXeAwQ==
X-Received: by 2002:a17:906:e01:: with SMTP id l1mr1561025eji.425.1590507188371;
        Tue, 26 May 2020 08:33:08 -0700 (PDT)
Received: from [192.168.43.105] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id bz8sm177630ejc.94.2020.05.26.08.33.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 08:33:07 -0700 (PDT)
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
References: <20200526064330.9322-1-xiaoguang.wang@linux.alibaba.com>
 <fe4196c6-a069-a029-6a98-68801d088798@gmail.com>
 <06081761-4aef-6423-ac70-97c62a7c0e5c@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 1/3] io_uring: don't use req->work.creds for inline
 requests
Message-ID: <dc2f20fd-dd81-bc21-cd02-747b523dd915@gmail.com>
Date:   Tue, 26 May 2020 18:31:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <06081761-4aef-6423-ac70-97c62a7c0e5c@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 26/05/2020 17:59, Xiaoguang Wang wrote:
> hi,
> 
>> On 26/05/2020 09:43, Xiaoguang Wang wrote:
>>> In io_init_req(), if uers requires a new credentials, currently we'll
>>> save it in req->work.creds, but indeed io_wq_work is designed to describe
>>> needed running environment for requests that will go to io-wq, if one
>>> request is going to be submitted inline, we'd better not touch io_wq_work.
>>> Here add a new 'const struct cred *creds' in io_kiocb, if uers requires a
>>> new credentials, inline requests can use it.
>>>
>>> This patch is also a preparation for later patch.
>>
>> What's the difference from keeping only one creds field in io_kiocb (i.e.
>> req->work.creds), but handling it specially (i.e. always initialising)? It will
>> be a lot easier than tossing it around.
>>
>> Also, the patch doubles {get,put}_creds() for sqe->personality case, and that's
>> extra atomics without a good reason.
> You're right, thanks.
> The original motivation for this patch is that it's just a preparation later patch
> "io_uring: avoid whole io_wq_work copy for inline requests", I can use
> io_wq_work.func
> to determine whether to drop io_wq_work in io_req_work_drop_env(), so if
> io_wq_work.func
> is NULL, I don't want io_wq_work has a valid creds.
> I'll look into whether we can just assign req->creds's pointer to
> io_wq_work.creds to
> reduce the atomic operations.

See a comment for the [2/3], can spark some ideas.

It's a bit messy and makes it more difficult to keep in mind -- all that extra
state (i.e. initialised or not) + caring whether func was already set. IMHO, the
nop-test do not really justifies extra complexity, unless the whole stuff is
pretty and clear. Can you benchmark something more realistic? at least
reads/writes to null_blk (completion_nsec=0).

-- 
Pavel Begunkov
