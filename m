Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67BB41194F3
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2019 22:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727697AbfLJVR0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Dec 2019 16:17:26 -0500
Received: from mail-pf1-f174.google.com ([209.85.210.174]:38090 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728861AbfLJVM5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Dec 2019 16:12:57 -0500
Received: by mail-pf1-f174.google.com with SMTP id x185so447861pfc.5
        for <io-uring@vger.kernel.org>; Tue, 10 Dec 2019 13:12:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RVHzytoFKmxp71fLK8zwWumSvcrUcgiercZQ4sj+tQs=;
        b=Y4KqN8Z1+G+DQ6I91zdwl1tThKHZXbN9IHG/kHPpbi0qD92ARIlURi3zrreR0AwTsD
         rsS4Jmih+9ruNqRgghQd0c/2BhPfQtvrEjbCCoNPEvqiHiXl3nCOI/eihg80yv1VnHSV
         JmAnVICy1mOltAk5W2ESvsPdlbr69KcnAuvDaQ17hTMQxeAH7C6IBe9WdwJsgVe2KTPD
         9Or8XaQ6nOAMMhSy+uHid04DnkDizHdFsnulLf4BU6fjbxCzoF5i4SNxMRMCeVyI+V1P
         bBi0BwQaG+34AfPgmWEFeXSC/I4GNBZcddxqm8/bPUQmqDSa+7p10Ieyz8bzxEENVTQH
         j+1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RVHzytoFKmxp71fLK8zwWumSvcrUcgiercZQ4sj+tQs=;
        b=MRY8oUYC33l3f6BEouYAWxJ4z/GqtNn6bc1igXWe2tko34uCpOumSXSLFvJKb6UjTK
         QcC610sBIxbsjWue8w3GWcfzbxKgsMIx5oFJEFeSooKl2VYYHwmcezQQ0gV6Nt/WiHBu
         SNNT8VmnRglGnEHs/71v20QtdPqTq1JpJ7FDQ2g5g9a0eilr4kOpGsEbZWg9R1LNNyRD
         a+hmUvhJwSjQ34HFKmpOcmnYpUK1NIYre94+peGw5p1p8hUrolVAB59ry3PB0DYT67jW
         w8poxSrUrUAS651IvwHmEdVHuat2uqISDlBunCiiIbZIHNXfHatucaa5aDLmhZpYJjpM
         58hQ==
X-Gm-Message-State: APjAAAWUx+4kHvTUy9/sYqwFJDACG1yajGl73nZTbDZo4qVp4HKe2bhd
        W7BHelwil//X3GW0X0iU5mE1HAIkP8I=
X-Google-Smtp-Source: APXvYqyjzdzfwzhpwgSViB4SArfQ8GAco9voKZJjasYu5IC6XOdvTr7bF/yg/61DwxdTvHIWA6+4DQ==
X-Received: by 2002:a62:1548:: with SMTP id 69mr37952583pfv.239.1576012376620;
        Tue, 10 Dec 2019 13:12:56 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1131::1215? ([2620:10d:c090:180::4a7a])
        by smtp.gmail.com with ESMTPSA id b16sm4394227pfo.64.2019.12.10.13.12.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2019 13:12:55 -0800 (PST)
Subject: Re: [PATCH 01/11] io_uring: allow unbreakable links
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org,
        =?UTF-8?B?5p2O6YCa5rSy?= <carter.li@eoitek.com>
References: <20191210155742.5844-1-axboe@kernel.dk>
 <20191210155742.5844-2-axboe@kernel.dk>
 <e562048a-b81d-cd6f-eb59-879003641be3@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <15eb9647-8a71-fba7-6726-082c6a398298@kernel.dk>
Date:   Tue, 10 Dec 2019 14:12:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <e562048a-b81d-cd6f-eb59-879003641be3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/10/19 2:10 PM, Pavel Begunkov wrote:
> Apart from debug code (see comments below) io_uring part of
> the patchset looks good.

Hah, oops!

> Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

Thanks

-- 
Jens Axboe

