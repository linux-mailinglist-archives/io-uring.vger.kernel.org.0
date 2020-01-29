Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF7DA14C43F
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2020 01:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgA2AyV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jan 2020 19:54:21 -0500
Received: from mail-pl1-f170.google.com ([209.85.214.170]:40704 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbgA2AyV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jan 2020 19:54:21 -0500
Received: by mail-pl1-f170.google.com with SMTP id y1so2271014plp.7
        for <io-uring@vger.kernel.org>; Tue, 28 Jan 2020 16:54:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RiPMvkt6DEYMYLoCVz2P/tYA2+jfqHtO3bUEPMPhHCI=;
        b=WnLzdRRF9MJH1U+Qi1SeojlU9gvH2eTAw/8wHiEkU8iFNRE+ihD1Bg/YBRIP8zGeN5
         4gJMzxb254oq305Z15NXjiVpFASLIG5HtRJ72whBpoy395UGV4l+3I9i1uA7Xgur7FoX
         fzJE58L93e32k2dnWI5LUae1bV6KBZLy7oY8uzMnkTbl/0uZFvmwkASLtbH5FJHemPmO
         iEfvjk8vbnpQVXSNxGS7kpcEiAdhhHJJzx7wKkj3G2xFHulY1kI37wL/JyqMdWV+D76t
         fSRF/M8/JKlIvMSJ/gk816LGxOgckNRLMCffQGzeJDMUfwvPmWXyUtZLW7MzBmBbyDl1
         O5sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RiPMvkt6DEYMYLoCVz2P/tYA2+jfqHtO3bUEPMPhHCI=;
        b=NxsL/IeAekGHbQdoTiz3uVgV/ODpnTum6hmJELTqt8hDiaNjjnfnJtRnfuOadwD58e
         6S2ktm5lLjb5hBM6SB2TeTO+vpMetadKXfruq2EXFaHD2HsqsESqgPMK+T+zehuE/NW+
         un+GUOOC+nGMGuh5ofKT0N9FfdQVCU81Am47u8LSm7S02rTfzPgjRs0Yyn8NOKyPvcQN
         iKaczjkwDudoxyjLMqMh3yGySCrh6B0HimglbMK1TUrwEsfy0G2wDkIlpBH7mFNXDx4K
         SXSBGLBsZmndcKQADDx4T9ORa3zXEraKFsGIOXFSvX7QbPRyI0L1fNqDzQM1srpN9flP
         uEAA==
X-Gm-Message-State: APjAAAXimcE74NWVav18K/CEH0ws1zddGrgBpTRVjcjzYQqKcoMnX7lT
        /M2w9QLgEcCTNB8EwOWu3xcMDopEpQE=
X-Google-Smtp-Source: APXvYqzb8RJPiiHeReoXIkWVNhaqxJ8aLsXs6aYl85BwUlaqsSsNfxmPWMyrPR9ce+MRz4vOi9c/5g==
X-Received: by 2002:a17:90a:bd97:: with SMTP id z23mr7985149pjr.19.1580259260429;
        Tue, 28 Jan 2020 16:54:20 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id s1sm247412pgv.87.2020.01.28.16.54.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2020 16:54:19 -0800 (PST)
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Metzmacher <metze@samba.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9@samba.org>
 <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
 <2d7e7fa2-e725-8beb-90b9-6476d48bdb33@gmail.com>
 <6c401e23-de7c-1fc1-4122-33d53fcf9700@kernel.dk>
 <35eebae7-76dd-52ee-58b2-4f9e85caee40@kernel.dk>
 <d3f9c1a4-8b28-3cfe-de88-503837a143bc@gmail.com>
 <c9e58b5c-f66e-8406-16d5-fd6df1a27e77@kernel.dk>
 <6e5ab6bf-6ff1-14df-1988-a80a7c6c9294@gmail.com>
 <2019e952-df2a-6b57-3571-73c525c5ba1a@kernel.dk>
Message-ID: <0df4904f-780b-5d5f-8700-41df47a1b470@kernel.dk>
Date:   Tue, 28 Jan 2020 17:54:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <2019e952-df2a-6b57-3571-73c525c5ba1a@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/28/20 5:24 PM, Jens Axboe wrote:
> On 1/28/20 5:21 PM, Pavel Begunkov wrote:
>> On 29/01/2020 03:20, Jens Axboe wrote:
>>> On 1/28/20 5:10 PM, Pavel Begunkov wrote:
>>>>>>> Checked out ("don't use static creds/mm assignments")
>>>>>>>
>>>>>>> 1. do we miscount cred refs? We grab one in get_current_cred() for each async
>>>>>>> request, but if (worker->creds != work->creds) it will never be put.
>>>>>>
>>>>>> Yeah I think you're right, that needs a bit of fixing up.
>>>>>
>>>>
>>>> Hmm, it seems it leaks it unconditionally, as it grabs in a ref in
>>>> override_creds().
>>>>
>>>
>>> We grab one there, and an extra one. Then we drop one of them inline,
>>> and the other in __io_req_aux_free().
>>>
>> Yeah, with the last patch it should make it even
> 
> OK good we agree on that. I should probably pull back that bit to the
> original patch to avoid having a hole in there...

Done

-- 
Jens Axboe

