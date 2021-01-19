Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBBE32FC48C
	for <lists+io-uring@lfdr.de>; Wed, 20 Jan 2021 00:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbhASXOj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jan 2021 18:14:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbhASXM0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jan 2021 18:12:26 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD889C061575
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 15:11:42 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id 7so14071640wrz.0
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 15:11:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=V3M3PoRxhV2fDgqrdysKsNxr+TNl9SjPpj1PmwUyyKE=;
        b=YiqLhSifghE9tyUDMzWghoz1PlTGa5qbreL7RNUC4OjEgL7bwRKR7i0r7pZDtBJ9Bs
         flMpPo6ii8UMSFHR7zzxgMjVN0MHLHHevAYpo7EGjT/PlPOucgwt0LLstyMogQQBYlxl
         QIO+xbk2qfqy/H/G6gu48bUZboAHxSavFWTkyCVPJEWRPvhDU7qPNgMSGvqK/gua9bVX
         rbeSyqX1fSyjgV1Vcne28LJaHavm3lTqcwaome+ao/jH+/CkPop1EZkzOkWgTQ+2xpKU
         3bh1H9Vtfj8O0oScpyCIw7ji7YVScEPZkTz+iBkjGVk5hsOTMV+Ox8+d/IPuhp0MEmpT
         TcGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=V3M3PoRxhV2fDgqrdysKsNxr+TNl9SjPpj1PmwUyyKE=;
        b=EjAIdaWKeOfeCRJUqpzP9wUoJ3+HbMCROjwkHhD6gtIwE8HfERPUcxH7pqineRdL4U
         G0dQptyrB8y/K/Ua85YSplGmd/ymf2o40TNG749MHy1dJvnwnqOeWiXeWvJiMFbm4MLI
         IHenuLqGzn939kgV5rCoNO4JTaFh0pMmo2R08e6QmJPzmu0KcOhs5jQsINPkQbiDfHRg
         fuBvnNEjZFvlpQkrRj745DZCdzaUOHwdpEIhqQ7jMEVY7iatGlI2fqgg3W46hdGrdj/o
         Tqo98yMJlrQ8H8JaZ3lPswE52zXKhiQZeCTPuL4wLxLIX5VD21p7LcKfp0Idj1GUptLK
         fsjQ==
X-Gm-Message-State: AOAM530bKRtVvQowouXB7AO8FInCma7cb3ckuQPqF05LW0ovs8BCj2h5
        hSkds07x8LfUlr4h5oufuA5j0EZt0PQ8DA==
X-Google-Smtp-Source: ABdhPJz8+f0jVy/QGMn+dgWZcoZgplzNzqY2mXfZi/k/xCsQYojARiVQ4rXUmoFXd5jjrQfHr6/gGw==
X-Received: by 2002:adf:fbd2:: with SMTP id d18mr6538192wrs.222.1611097901428;
        Tue, 19 Jan 2021 15:11:41 -0800 (PST)
Received: from [192.168.8.135] ([85.255.234.152])
        by smtp.gmail.com with ESMTPSA id a24sm375522wmj.17.2021.01.19.15.11.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jan 2021 15:11:40 -0800 (PST)
Subject: Re: [PATCH 10/14] io_uring: don't block resource recycle by oveflows
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1611062505.git.asml.silence@gmail.com>
 <f4332081e1c60460686075e16534ecf6a337cfc8.1611062505.git.asml.silence@gmail.com>
 <c18325d0-fa84-a40d-267b-cef83c84e12d@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <6fd69c4a-25db-bcd1-e42a-5a8ddeb9ef92@gmail.com>
Date:   Tue, 19 Jan 2021 23:08:04 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <c18325d0-fa84-a40d-267b-cef83c84e12d@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 19/01/2021 22:59, Jens Axboe wrote:
> On 1/19/21 6:32 AM, Pavel Begunkov wrote:
>> We don't want resource recycling (e.g. pre-registered files fput) to be
>> delayed by overflowed requests. Drop fixed_file_refs before putting into
>> overflow lists.
> 
> I am applying this on top of the first 9 of the Bijan series, and
> hence this one is borken now. I've applied the rest, please resend
> if necessary

Ah, indeed, forgot that it would be. Thanks!

-- 
Pavel Begunkov
