Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1C13196EE
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 00:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbhBKXrq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Feb 2021 18:47:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbhBKXq7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Feb 2021 18:46:59 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4955BC061574
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 15:45:52 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id q10so1243014plk.2
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 15:45:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=oaBH2psaxi0QmlDEFpzn6H9XUPMhomHx2+dCWKtXc8Y=;
        b=E8B//2b1QfdxnxoHG1RYi/OCd6Dbpl03EM0YDLcRHwDlDTUeFTL8pVT4KJoWtFMLQV
         IX7jh73pEvpHRQiPFsX/E8BjEAoPkZU9z30aldT4Oz3Ryqn+prt+oB6NVGi7T9ET+pkr
         wwBawopqNPDLKMZIhoQymBsEKGpjEmw7b5rAN34N1nQpo+OQKoiO7Ggu9UgaV9sW9HdR
         tDeXqiE/EIqNyHSxat4TwsEZkF6dlRBa4587rkmL2s/mvfvLRP3UsTr4HlW2xmjpQBVV
         AKAuEsKAzCwzzCNmRQOUPj+6CAO5R6pBzsP1r3dAl0kz+er0L1otsExvpntF5wwBDKfV
         /2HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oaBH2psaxi0QmlDEFpzn6H9XUPMhomHx2+dCWKtXc8Y=;
        b=glW1lC0wtuPErCJt5XYIPLqMuc6VrXRUB8sjZ6HBZ1wxKssAori/zQJddyIsxHU2qZ
         wvAAif+5bo4aah5pzRT6R3K8BspnQ6UD0B78r6gMOzY6UcDrNfW5rLzzES+Rf6XUhgBO
         v9tkvMX5QowB4mXv4RrRLhEtbEoSlCCcBkgPB5Y1LYbl0rcMFH9wF54rQcTkUU1umg6X
         s5pWyF0tRBA3dPz/55KUNDH4ouyoV+8MFnzqY5SR8ABrSsRpKPaRohYqYCW84XwRdsn6
         /YXfgUF4+Ji2jmVXBj+hsLXFMYk06uI7CdxpEBSTG+99uHUt93szJ6udSV81+OPJMUQD
         MtlQ==
X-Gm-Message-State: AOAM531Z/IxeGISSruoVCVBxEDu+YRwrzcKKM6RAgoZBM7WO0e3S0A7P
        VmGIAqPuUdvb2QbRTaSQLnMmQ7NlMO8vPtHY
X-Google-Smtp-Source: ABdhPJx9Z/+y+IJN9KhW1RbqNnQCIKPcSlt5NHXZciYmLkL2SaQKAw0cxw9UtQhIRZOBhCXfzuYRZQ==
X-Received: by 2002:a17:90a:ee8a:: with SMTP id i10mr138730pjz.103.1613087151538;
        Thu, 11 Feb 2021 15:45:51 -0800 (PST)
Received: from ?IPv6:2600:380:765b:563e:421b:410f:1678:8325? ([2600:380:765b:563e:421b:410f:1678:8325])
        by smtp.gmail.com with ESMTPSA id 62sm6436096pfg.160.2021.02.11.15.45.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Feb 2021 15:45:51 -0800 (PST)
Subject: Re: [PATCH liburing 0/5] segfault and not only fixes
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1613084222.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2e3b5c8a-2fae-061b-b3c9-019acaad4ef6@kernel.dk>
Date:   Thu, 11 Feb 2021 16:45:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1613084222.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/11/21 4:08 PM, Pavel Begunkov wrote:
> First 4 should be good and simple. 5/5 is my shot on the segfaults,
> take it with a grain of salt.
> 
> link-timeout failure is a separate beast, it's from the old times,
> and comes from the kernel's io_async_find_and_cancel() failing with
> ENOENT(?) when a linked-timeout sees its master but fails to cancel
> it, e.g. when the master is in IRQ or posting CQE.
> Maybe we just need to fix the test.

1-4 look fine to me, I don't like 5. I've committed a different
variant that I think better fixes the real issue of doing a
return that's too early.

-- 
Jens Axboe

