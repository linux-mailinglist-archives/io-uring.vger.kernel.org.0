Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B46653A9AA5
	for <lists+io-uring@lfdr.de>; Wed, 16 Jun 2021 14:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbhFPMof (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Jun 2021 08:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232452AbhFPMof (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Jun 2021 08:44:35 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE2AC061574
        for <io-uring@vger.kernel.org>; Wed, 16 Jun 2021 05:42:28 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id s23so2355434oiw.9
        for <io-uring@vger.kernel.org>; Wed, 16 Jun 2021 05:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Ov+6TdsxyPnAE/go4uKPTaq+xRfN+cq8OJH2b808SUw=;
        b=A4oVgkatl9TNacrtfcviixMIg2w3VwMxysVzP8wO7DgKtO8kcNFJX8iThUl71Pj5+Z
         3FyfOa+NpST8Bbq830FAWTicGvNDSSQIr5FJ5RbNjguoMRDYSj1u9xIduzXox8fWtWdP
         wbUPt5mb/NTcEoRBIbgC0k/PGxqrE6BNWXKdRBJbHL6SE2HKKFUwvjzYZliCXNoUs4Ij
         xik+ZCmuKFLBVAztg2AW6jtV/q96CWj8FxZjOCnQsmJrfuTWPaT9f6eYe5//QCyK/AzC
         sSyJBWcuBh7uAzJaV7nUzMosYHwxK7Xb1AZU5i/LztwJbMVE7SLO5DrR3TnBdZ9MELNR
         wlUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ov+6TdsxyPnAE/go4uKPTaq+xRfN+cq8OJH2b808SUw=;
        b=EETBcvuRsOVae1SpgACuwpt1eYGf9HU8M0BpitM+MTLexlruGm4k+UfUP5+X7uIb+Z
         h7UOlvuADFEeR5SORE/1QSldu9z7/zI/Yln3rxZckTIRAdbaW4CdAbXee9GQtKW2mT8T
         ySKo8TtzxpzfUJhph/Hkrl7LPJ0FgUL53yqKUrQmcb5pxSHvr+p5JSQHpm1BydQbGzpk
         3l+xzXWd6PN7JRdxlZjMZCNSyorhGBlKLZg1TU/Pfp5h58oKYj+kgpZDuVZxgNi68mz0
         KsVq3v4lVYAMGVM1lB/z/sR+avrR44eZsyimb2wULbt58uekdkuUlh+qIafXh11cV/CI
         aMxA==
X-Gm-Message-State: AOAM531niDa53vVjaUfxZKyE4Bcgn516Mh6IgJog5JXexy59RrcjpDGm
        eHHT3igIS1pDcqYMFmf389FQPA==
X-Google-Smtp-Source: ABdhPJwiM+LHbbFVezc5+6rmRihd65l8/VxGA9/ZTVL1axeq2pa1ZbpelZlJkgoFpT3TgG1fjW56gA==
X-Received: by 2002:a05:6808:1482:: with SMTP id e2mr3455908oiw.150.1623847347463;
        Wed, 16 Jun 2021 05:42:27 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id e10sm501276otr.5.2021.06.16.05.42.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jun 2021 05:42:27 -0700 (PDT)
Subject: Re: [PATCH v2 1/3] io_uring: Add to traces the req pointer when
 available
To:     Olivier Langlois <olivier@trillion01.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <60be7e1b.1c69fb81.986e4.c6b5SMTPIN_ADDED_MISSING@mx.google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7e219aa8-a7b0-a15b-531b-f8926d6d7f3c@kernel.dk>
Date:   Wed, 16 Jun 2021 06:42:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <60be7e1b.1c69fb81.986e4.c6b5SMTPIN_ADDED_MISSING@mx.google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/31/21 12:36 AM, Olivier Langlois wrote:
> The req pointer uniquely identify a specific request.
> Having it in traces can provide valuable insights that is not possible
> to have if the calling process is reusing the same user_data value.

Applied 1-3, thanks.

-- 
Jens Axboe

