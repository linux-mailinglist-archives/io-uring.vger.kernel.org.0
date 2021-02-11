Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 782A93193A3
	for <lists+io-uring@lfdr.de>; Thu, 11 Feb 2021 20:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbhBKT5E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Feb 2021 14:57:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbhBKT4F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Feb 2021 14:56:05 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41377C061574
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 11:55:24 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id d20so1457351ilo.4
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 11:55:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=5x04JyRgnS8VojaUuPFxA+wY9K5CX8AvtnDmQRBgeBE=;
        b=ESsCoBSzYTwhp+aPzR5kCcVpd5A4M7y0kidfh0NCRPOkYzmBoy4ky1wsTU1u8NQ/tQ
         TP3IpsrJDuZ3RLSCREdfz/2UKx+GtcMQZKLbKAAmwOYn01neuzLyTFWJfpqlakdYJzfP
         KwXv2sSB0yRCwnPMQN6a9WTOrDGkj/1K2Op1PCiwoam4ZFR9iyA+4AGEW/+zP9vcDTwX
         54lTmzOw/WVcYqLSANjFVtm9Tf/7xIVZ3s7OePsEz8Z0cJHIWbROjUgwzi3AuA4BBXsM
         ZsP6Ni69rNTOuxKdj11Q+iKJ8x0EaleaSneXMh/CzpuwMEgJBqF1HgD4UEt626+Jcnii
         GESg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5x04JyRgnS8VojaUuPFxA+wY9K5CX8AvtnDmQRBgeBE=;
        b=Ggq4s24Q5ng36JuNdj+tPpSMEl+KrGMUENiQWM1H9HV3VaS/+7qhBTvEf8M5SPFqaf
         l1Ao37lteL7LDSEn8ZPK8blU+/zSYsaOGJ3X7QJlgFAP5nsLz3IFHm8YikYn5C8Ihn9P
         jTiDnBpVUsHf9MVkexgLQ12d3D66Zi3cu1zjfDvsjyNb2Ew7U+l/ywUoXDSlpt15CGe/
         iSPBvHjRuRRBs1PVtZf7NHKRO+6Hkc+H37T6BDn01gE96fTEqDETBCpo7AIygq7K5S48
         nVyyL/BmL45rI5wEViMGXHCiA3JZrVgpkrZVzvJujRn7wRgovk+grOpA2qIo0AW7abeU
         G+oQ==
X-Gm-Message-State: AOAM531x7P/aqk6A5lTfvuFaQT98MRxlR1R1KxRw8uwjJIyi5le6yVn6
        owDzmhm5Bp84ZEMShbkxqT3Y5iZwPyz7R/Nr
X-Google-Smtp-Source: ABdhPJzBtPy9cuCgFkkSq4pQUXMT1JBbYnwoI7eS5K0uWChxdTwgLjkKlZ7QY8yZl+lLK29mHfoezg==
X-Received: by 2002:a92:660d:: with SMTP id a13mr6890585ilc.268.1613073323168;
        Thu, 11 Feb 2021 11:55:23 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id i4sm3053366ioa.30.2021.02.11.11.55.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Feb 2021 11:55:22 -0800 (PST)
Subject: Re: [PATCH for-next 0/4] complete cleanups
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1613067782.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <637a899f-b6b9-2775-0c19-827842f60d37@kernel.dk>
Date:   Thu, 11 Feb 2021 12:55:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1613067782.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/11/21 11:28 AM, Pavel Begunkov wrote:
> Random cleanups for iopoll and generic completions, just for shedding
> some lines and overhead.
> 
> Pavel Begunkov (4):
>   io_uring: clean up io_req_free_batch_finish()
>   io_uring: simplify iopoll reissuing
>   io_uring: move res check out of io_rw_reissue()
>   io_uring: inline io_complete_rw_common()
> 
>  fs/io_uring.c | 67 +++++++++++++++------------------------------------
>  1 file changed, 20 insertions(+), 47 deletions(-)

Good cleanups, thanks.

-- 
Jens Axboe

