Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B292D216077
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2020 22:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbgGFUox (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jul 2020 16:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgGFUox (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jul 2020 16:44:53 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC96C061755
        for <io-uring@vger.kernel.org>; Mon,  6 Jul 2020 13:44:52 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id y2so40839505ioy.3
        for <io-uring@vger.kernel.org>; Mon, 06 Jul 2020 13:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=rPip4IaXNsi/soZSxpHoj46mrbAbhitrYZnmAqlfDrU=;
        b=W70U42E+RF+ahjRTRJxqUJxj2PkRvmfPEc9buCXhXf6nDdg2sOCVBPPDBnkW1MfIhQ
         8vy31FTHP2rVNbuV5y5O/lZTQQuK4JI2BPoxYdbF7lKxn+3+5Q3oTkrtGVJu4XemdjEn
         l3YlKjMVd5+aKtGt1OFct0CfBr/0zp0VCKG39yj3XlsXazMHlDwCwpG/O5EEgVH0GEcM
         U99vmVIbl6j/QfSKukGCmCOhw8X2LGKoWWbEzXCxeTJ5MWNfcAZjHfTqGSO/vpiyV2lm
         vaG0is1ucZcSujhqdjwR81yfpY+wx+95ZacvRRwVTDj839rvGRa+28WCtG7VdsjcYnty
         CXtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rPip4IaXNsi/soZSxpHoj46mrbAbhitrYZnmAqlfDrU=;
        b=XRX5k2nrIH7TAeG9f1zp5848FI3rBxMlqLlKHZHWYjYP+N4/VBzxTy4wPi4aZggG9v
         C3g+90C38fDemXARx/m+waJaq3TwLeG1BMuGG6k1RqhZeVWckZCuEeeJlifOs0ehNBs+
         tIArXBVnSzBdVD+hLkoUqeO7xuLrMsWtHuJcCP5gasVIuGWhmwZbeSxOg0x0UFyPIR4+
         csAG0Q/zYcDETopeoSU58FiXYSx8ECBQZsG7IksIvc6jY6A4NlLHZrf7aV0fV0P1tf2x
         fkc3N/qL/tk1DSEbNgjEjL4p8vd3O67d3EwfM2UYeBb+8Lys0dPyW9brDy1j8xDaVcVD
         BEwQ==
X-Gm-Message-State: AOAM531i38kkTt5OJfPCoM6zYEbylMwc9XBE8arf9onAwOd4koAnf6W3
        i934IC5xoQfd1vhLtyGpKdkz8d96VUEtvQ==
X-Google-Smtp-Source: ABdhPJxMDf+cYPmQyk44DEqFEarLRa0PJQXJ9Yhqj9WOIlA9ZJRw+lvxI4GUrI6gDc02aKHeumBK4A==
X-Received: by 2002:a6b:b457:: with SMTP id d84mr27430358iof.21.1594068291775;
        Mon, 06 Jul 2020 13:44:51 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l22sm10746056ioc.24.2020.07.06.13.44.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jul 2020 13:44:51 -0700 (PDT)
Subject: Re: [PATCH] io_uring: add support for sendto(2) and recvfrom(2)
To:     Alex Nash <nash@vailsys.com>, io-uring@vger.kernel.org
References: <20200706180928.10752-1-nash@vailsys.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fdd60247-293c-a510-9a67-8428bd7456e8@kernel.dk>
Date:   Mon, 6 Jul 2020 14:44:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200706180928.10752-1-nash@vailsys.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/6/20 12:09 PM, Alex Nash wrote:
> This adds IORING_OP_SENDTO for sendto(2) support, and IORING_OP_RECVFROM
> for recvfrom(2) support.

I'll ask the basic question that Jann also asked last week - why sendto
and recvfrom, when you can use recvmsg and sendmsg to achieve the same
thing?

-- 
Jens Axboe

