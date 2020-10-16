Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53AAF290B19
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 20:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390831AbgJPSHX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 14:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390732AbgJPSHX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 14:07:23 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E652C061755
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 11:07:23 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id e10so1953457pfj.1
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 11:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GJ0kW23Ft7kWH2L+opK74RczYd3mTtbU1W4ReHf2wes=;
        b=XY5Y7p5QtxRuSw0s8op8laLGN1x/0bHaeejX4lFztMjppPwiehLWiY2y+X17MyA/YX
         W4aagBo/SZFPaVx7CjuCWTqzaFGJ8ekZiPC7AfEVSeKT301Mk2c8zm5eRkrcLZmOL1cD
         33s7QxQzaTbSyB/ak/9eSkQQJHF0e4XB+F9p6/UmioVNNjbv923RXtXWlnwL7bnSWgPE
         MrQUP4DedDsJpztWyEWi7bd7TENuLPy/wyx+rg0OMxjlez6RhBd79ccI/+NpgqoIYJfj
         8NRjIkim8/UahBCMNW7UaPMuvIgGK87ykuVo/czcznvz5K5RAho2kTvqO2Q2IFskPne2
         1+zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GJ0kW23Ft7kWH2L+opK74RczYd3mTtbU1W4ReHf2wes=;
        b=gw3Nz/yn0cEvJ8RC1bOY2Vkifx4EPELjJwV+DLTfSUW++jcz+8YoMkH11bQ6gub3L3
         aMNkVfQEbeaXc8WMU5d9xu4LAsKvCTQQOUBqXfmN1lfvBWrYWbH9fW3f40uVUfcObteg
         GvYEDkjh2l7fPr6wJZkncY18QpV2RoCFCmrowRWEyCoN0NqVHtFOyzDHcBoAfQLaFrc+
         u58s/sp/U5Zz8XeOuyy25BBEphcPGt1neHqzEGQD+rU3ae+BcWOgC5nN57oPrHiDE7Js
         EKv6Q8HToqGssnX3yqm+1KT6712EECFAf2ANXMpbdDUY9f2VFbv5QpIrOjDDYzGTFOEg
         a7Dg==
X-Gm-Message-State: AOAM532WaxQ5hpZXU1L684l/GxiVXUr/Rnr//znhMIC+0OJ69pcOYcKT
        cuXXCkned+zZOahlZ7e4SUEk0uj7eI6OYfDf
X-Google-Smtp-Source: ABdhPJyttTkUxmZoD0Pgnp7k3WrSY+ASrIX7oi3nhBE1KZq63c5P53fwgPS446EK0NGdb83pMsrmdA==
X-Received: by 2002:a63:5b60:: with SMTP id l32mr4300008pgm.134.1602871642764;
        Fri, 16 Oct 2020 11:07:22 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id c21sm3609040pfo.139.2020.10.16.11.07.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2020 11:07:22 -0700 (PDT)
Subject: Re: io_uring possibly the culprit for qemu hang (linux-5.4.y)
To:     Ju Hyung Park <qkrwngud825@gmail.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Cc:     io-uring@vger.kernel.org, qemu-devel@nongnu.org
References: <CAD14+f3G2f4QEK+AQaEjAG4syUOK-9bDagXa8D=RxdFWdoi5fQ@mail.gmail.com>
 <20201001085900.ms5ix2zyoid7v3ra@steredhat>
 <CAD14+f1m8Xk-VC1nyMh-X4BfWJgObb74_nExhO0VO3ezh_G2jA@mail.gmail.com>
 <20201002073457.jzkmefo5c65zlka7@steredhat>
 <CAD14+f0h4Vp=bsgpByTmaOU-Vbz6nnShDHg=0MSg4WO5ZyO=vA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <05afcc49-5076-1368-3cc7-99abcf44847a@kernel.dk>
Date:   Fri, 16 Oct 2020 12:07:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAD14+f0h4Vp=bsgpByTmaOU-Vbz6nnShDHg=0MSg4WO5ZyO=vA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/16/20 12:04 PM, Ju Hyung Park wrote:
> A small update:
> 
> As per Stefano's suggestion, disabling io_uring support from QEMU from
> the configuration step did fix the problem and I'm no longer having
> hangs.
> 
> Looks like it __is__ an io_uring issue :(

Would be great if you could try 5.4.71 and see if that helps for your
issue.

-- 
Jens Axboe

