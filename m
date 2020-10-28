Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5879129D4A2
	for <lists+io-uring@lfdr.de>; Wed, 28 Oct 2020 22:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbgJ1Vxk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Oct 2020 17:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728434AbgJ1Vxi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Oct 2020 17:53:38 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA981C0613D1
        for <io-uring@vger.kernel.org>; Wed, 28 Oct 2020 14:53:37 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id p7so1110654ioo.6
        for <io-uring@vger.kernel.org>; Wed, 28 Oct 2020 14:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=LjzZyERfBshbfOsnhqRr8v6KHucr3e1FtfldMxWiT2A=;
        b=K2Zzo/FKoCdCkWwwEr8WnH6tWPzDbx7ETgNfdPZJhUdOw0dE9Th1fJI5+H5kWszZiX
         C4vkXS93UcPQQOtUHweMK+YRfwb5wjeQJTLJq3hfxJd2kYwc3bCKgi+UIQlI+9o68QyB
         9Vqzdv+wPsX12utqa+oR1l7bLb67bmnuzpH+NDgBOSdXIjpEK9avrEW4/YlyBlq3GaLx
         ltc9QfVkbNiQvtDszUko3CvcTFNZB1hzjxuCv8NWdEajg77DeG/XozIFYfuKD6hkg4/S
         StvVFH99rie4AIk9Cy8VtrtXiSNMgUIXHWT5aF3YSLbhnA6rGrxwtSdfg+9iaFHMVHK+
         ZQng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LjzZyERfBshbfOsnhqRr8v6KHucr3e1FtfldMxWiT2A=;
        b=qVpRFKs5EWXQnV7bMybzU6RcI5Mo6Wowh5yHvCceUYlRBYfqfuznAIoSqbP8icuwmi
         DFyhQ//D86BtpgizTIREU98ss4Ol2jFb8xfYWQOFwXOSpMd5u6MhBv5Yq7boFH2x0WPn
         /j7fNvEKM7KOfdvKKEtCc4UaD60ZnCvR/u5Ta0e1XPmHErYjBb9st7QzvnGADYWiggGU
         xduIWg0m0lgF1W2BIoExzQeqFzCfhrpE27vGQ6vgfidciQz+z+cLw+efA7QHo9m1hvqe
         9K936fq5Dn9xcwD+sYJsbIIEGO/kuMF8SE1Pc0GSTd0Z6XhMNv5L5YOG8PNgQ9riPNVQ
         TOUg==
X-Gm-Message-State: AOAM5310CbEPhJTBubiDR0lkmgANsFWA+OtXf3d7AZbicSUgjuXFQVlp
        YYDnWh9GKs1DtyG2ttaH+Qd0v8rQH6pMXg==
X-Google-Smtp-Source: ABdhPJwhqu2l/zU3AhQobKJUTI8G3WDRRsd45RWfotFRsiLme9gf9Rf7lwdS+fw+gUKtIrGfimTxUg==
X-Received: by 2002:a05:6602:2f8c:: with SMTP id u12mr1300272iow.122.1603894728089;
        Wed, 28 Oct 2020 07:18:48 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id u18sm1547471iob.53.2020.10.28.07.18.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 07:18:47 -0700 (PDT)
Subject: Re: [PATCH v2 0/4] singly linked list for chains
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1603840701.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <31af9b88-cc16-f789-767b-30489c33935f@kernel.dk>
Date:   Wed, 28 Oct 2020 08:18:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1603840701.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/27/20 5:25 PM, Pavel Begunkov wrote:
> v2: split the meat patch.
> 
> I did not re-benchmark it, but as stated before: 5030 vs 5160 KIOPS by a
> naive (consistent) nop benchmark that submits 32 linked nops and then
> submits them in a loop. Worth trying with some better hardware.

Applied for 5.11 - I'll give it a spin here too and see if I find any
improvements. But a smaller io_kiocb is always a win.

-- 
Jens Axboe

