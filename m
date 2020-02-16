Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB83160717
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2020 00:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbgBPXHl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 Feb 2020 18:07:41 -0500
Received: from mail-pf1-f178.google.com ([209.85.210.178]:36469 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgBPXHl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 Feb 2020 18:07:41 -0500
Received: by mail-pf1-f178.google.com with SMTP id 185so7858423pfv.3
        for <io-uring@vger.kernel.org>; Sun, 16 Feb 2020 15:07:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EYwmkUqBENYpbylKRtHxYlx2JlSRoF3AMLA1qt8byx4=;
        b=JTZUsezaK8551TiAAClqgteeBga/I3kSj2+G4LeD9Q7vkI6zybkl8AApZbXkgakei2
         TD8BoCon/SzKo0IxtT63knl6NL/ESXBp5Lu7Otdhc1i3bpzQrnbbyxRbQZpNvYwZ1QyL
         Sa2TsyXwio331bMi28CV3x8a53dfKIOnbWaILb3LFvQx5+M4k2YnRwUMby8S8srGhgrT
         avwb8mRxn4dE/4Arj4GOqyJhxWAZ80l3GqZMSqn2012PTSPriyB14P32b/8g5gaf6SBk
         SQLZrJvI4L//o2eXNKKPN+8V6IRUWVmCgrQAzXFXc12Gzjcke2PAxAZcg5GlPwzQx+PS
         IcFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EYwmkUqBENYpbylKRtHxYlx2JlSRoF3AMLA1qt8byx4=;
        b=Eozk4deCEJg0Uy9wfKEruof47YDKSDP5GtRi3XeaA6kTvVAsXH+C7mvdtemG1t0Kc2
         E+iMsg7UxJWvh3zBWk4jpzvnCMlJK4ErFCgO0pNVFkp1JSJ6Gb0xyboeaPm9R2sVnDyI
         geGsXPoRsgWKvBQpVlTRCAKuq8PjwIboxaQsqwXLXxYxuhVw7mD2elUZPZW6SHOagXXA
         o1A468HGS1lKf1ysaBC+a9Mmk0PpVAVupHfa+x22LCdLt6AoWGUmAJhfU94zVYRQuuE+
         nq/O3ahe40Rar8sMwdkcCSARNhcWEJVq2BfgoLUcD+ER8zn7vUNjcsFjqO36ZtXrVtHR
         RSHQ==
X-Gm-Message-State: APjAAAW9lpj5e/cdnvnAycIcoCoMGyp+JGs1mNySH6K/1RDnnxTVmKC2
        C32bZBicfLOMUXDZgda7v5qtgOQNlB0=
X-Google-Smtp-Source: APXvYqxsmnMv6YWDkcfR6PlZPR4iCGCgWEwVr9HsFFVMDbTCS2psHBOetFSQROUEhoPQ6aXfbRd/sg==
X-Received: by 2002:a63:4b65:: with SMTP id k37mr15114649pgl.46.1581894460717;
        Sun, 16 Feb 2020 15:07:40 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:6cdc:d83a:55b1:9a10? ([2605:e000:100e:8c61:6cdc:d83a:55b1:9a10])
        by smtp.gmail.com with ESMTPSA id o29sm14296469pfp.124.2020.02.16.15.07.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Feb 2020 15:07:40 -0800 (PST)
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        io-uring <io-uring@vger.kernel.org>
References: <9FEF0D34-A012-4505-AA4E-FF97CC302A33@eoitek.com>
 <9a8e4c8a-f8b2-900d-92b6-cc69b6adf324@gmail.com>
 <5f09d89a-0c6d-47c2-465c-993af0c7ae71@kernel.dk>
 <7E66D70C-BE4E-4236-A49B-9843F66EA322@eoitek.com>
 <671A3FE3-FA12-43D8-ADF0-D1DB463B053F@eoitek.com>
 <217eda7b-3742-a50b-7d6a-c1294a85c8e0@kernel.dk>
 <1b9a7390-7539-a8bc-d437-493253b13d77@kernel.dk>
 <20200214153218.GM14914@hirez.programming.kicks-ass.net>
 <5995f84e-8a6c-e774-6bb5-5b9b87a9cd3c@kernel.dk>
 <7c4c3996-4886-eb58-cdee-fe0951907ab5@kernel.dk>
 <addcd44e-ed9b-5f82-517d-c1ed3ee2d85c@kernel.dk>
 <b8069e62-7ea4-c7f3-55a3-838241951068@kernel.dk>
 <FA1CECBA-FBFE-4228-BA5C-1B8A4A2B3534@eoitek.com>
 <f1610a65-0bf9-8134-3e8d-72cccd2f5468@kernel.dk>
 <72423161-38EF-49D1-8229-18C328AB5DA1@eoitek.com>
 <3124507b-3458-48da-27e0-abeefcd9eb08@kernel.dk>
 <5cba3020-7d99-56b0-8927-f679118c90e9@kernel.dk>
 <68a068dd-cb14-10a5-a441-12bc6a2b1dea@gmail.com>
 <286b00c4-bff7-6c1a-b81f-612114637019@kernel.dk>
Message-ID: <fbef5ad9-66d0-1d04-16d3-4111c2020911@kernel.dk>
Date:   Sun, 16 Feb 2020 15:07:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <286b00c4-bff7-6c1a-b81f-612114637019@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/16/20 4:06 PM, Jens Axboe wrote:
>>> +			else if (!retry_count)
>>> +				goto done_req;
>>> +			INIT_IO_WORK(&req->work, io_wq_submit_work);
>>
>> It's not nice to reset it as this:
>> - prep() could set some work.flags
>> - custom work.func is more performant (adds extra switch)
>> - some may rely on specified work.func to be called. e.g. close(), even though
>> it doesn't participate in the scheme
> 
> For now I just retain a copy of ->work, seems to be the easiest solution
> vs trying to track this state.

Should mention this isn't quite enough, we really need to drop anything
we have in ->work as well if it was already prepared/grabbed.

-- 
Jens Axboe

