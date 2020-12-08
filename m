Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6782D36A9
	for <lists+io-uring@lfdr.de>; Wed,  9 Dec 2020 00:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730438AbgLHXDd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Dec 2020 18:03:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbgLHXD3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Dec 2020 18:03:29 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A22C061793
        for <io-uring@vger.kernel.org>; Tue,  8 Dec 2020 15:02:48 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id v14so24219wml.1
        for <io-uring@vger.kernel.org>; Tue, 08 Dec 2020 15:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GLhMruIQmSSdEhx+WlbJM7nyVIURsXUQlNkDXIDcIB8=;
        b=ce6PMXxZ13tJ8UmeFpvbdn15S2fnlTUhPfl6CiMrIg9hyRN7yBpkYJZ2eyavZvtEI9
         9S/ZRrBNJ9gcCaEjs4+I04L20wgwPtEZCHX5ihyOu61kRADJnNpZMrA7mP9xS4uZe7+d
         6+tMtFIdrxWnUxgPRkXZ6vS4A/mTxIcAE06joUKGrSB3aXYScP7KZ7rKfMgzVXky6QdC
         RSs9Z4635MolBBu2o1fTRSO9Gzi3okLDzc4EQLDqElBBSgR1/t6AOQz4bPvPZZcwtZdb
         KJAdba0ukGWSBjIywwPooHrud4N7jLS0cSvstRZX96lYjQOnOr3LpCROPSasOaUt10Z/
         naoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GLhMruIQmSSdEhx+WlbJM7nyVIURsXUQlNkDXIDcIB8=;
        b=o37GXvX6kAQqF0JGwNUVHFPGuJi3cxV6blXtU1O8aCJU8t6PymFhcI/ld92MwmkDxn
         Hy46GqCCw940ArPWpveAco3ExvC7RDCJYjOHTJYilMqxTQCZETg49apsZxpdzwmF8Vh7
         GHEtSYb4oS2XJYaHYfckoKwEuBp1CuTT2v4Y69NTwMDpXDHY0hhwlOEWgYrNjaAYiSZx
         apzx/oin22m9E4EEyImBAkv2tkE9XZ6U3spH+wbwYwrt2IiB+dQAmrRoH2MA0UAzXYIk
         QY3T9DBRNo/QH/VGOcZc+obEg7doLvPOZUiY55NsNOKKYQyr88fmgjDJ9fVWGOTcY4CD
         6P+w==
X-Gm-Message-State: AOAM530FvJ3ySrvSeZpc0jzdKUjbUS5NE9qqY4pO23jcd9IMM7uL6e6Q
        HwvXfOtmp1EEnHaHBKrd2kvvo4bhLKjNWQ==
X-Google-Smtp-Source: ABdhPJy9j2LpBtJCHfG2q0Xo4LJtO2Hhmp8bO06gbVE7QIr8C8y6KqM2a25xYYEDKnajxPE1zXvopw==
X-Received: by 2002:a1c:f609:: with SMTP id w9mr98261wmc.72.1607468567151;
        Tue, 08 Dec 2020 15:02:47 -0800 (PST)
Received: from [192.168.8.119] ([85.255.233.156])
        by smtp.gmail.com with ESMTPSA id f7sm7163437wmc.1.2020.12.08.15.02.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 15:02:46 -0800 (PST)
Subject: Re: [PATCH liburing] rem_buf/test: inital testing for
 OP_REMOVE_BUFFERS
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <0de486be33eba2da333ac83efb33a7349344551e.1607464425.git.asml.silence@gmail.com>
 <08387f60-d2fe-1396-aa15-ae9b759efa57@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <e37a27d8-bbba-cc46-9acd-5773a25aec12@gmail.com>
Date:   Tue, 8 Dec 2020 22:59:31 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <08387f60-d2fe-1396-aa15-ae9b759efa57@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 08/12/2020 22:42, Jens Axboe wrote:
> On 12/8/20 2:57 PM, Pavel Begunkov wrote:
>> Basic testing for IORING_OP_REMOVE_BUFFERS. test_rem_buf(IOSQE_ASYNC)
>> should check that it's doing locking right when punted async.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>
>> NOTICE:
>> test_rem_buf(IOSQE_ASYNC) hangs with 5.10
>> because of double io_ring_submit_lock(). One of the iopoll patches
>> for 5.11 fixes that.
> 
> Let's get just that into 5.10, and then we can fix up 5.11 around that.

If you mean get that kernel patch, then it's the one I commented on
yesterday.
[2/5] io_uring: fix racy IOPOLL completion

Either can split this test

-- 
Pavel Begunkov
