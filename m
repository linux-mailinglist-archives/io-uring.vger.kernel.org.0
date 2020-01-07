Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECCFA1335BC
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2020 23:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbgAGW3C (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jan 2020 17:29:02 -0500
Received: from mail-pf1-f171.google.com ([209.85.210.171]:37934 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727185AbgAGW3C (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jan 2020 17:29:02 -0500
Received: by mail-pf1-f171.google.com with SMTP id x185so565174pfc.5
        for <io-uring@vger.kernel.org>; Tue, 07 Jan 2020 14:29:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=doUMgXWCBDro9Kh7/VFGJHRKe2LzA8nUSOuOR4+/4Uc=;
        b=Dmm4y+5nwCyRvkJU+nakGIPZlCNguO30/YLUguvNQAL4kwsl5rTkcYEXQxf7nqqp1e
         Rf/PgB/cuVIcSVai1/5oMmApghxDnq8wF2f4Kw3/YfKk1ESnTlZBJgHk1oVszY3J0YGh
         UvSoxA+Ydn8s7iXR6Nj28aBiKsJj3RRRyy+z93eyD/Zx6Zlb07Ua+kW7SraABCvuRqYL
         iSmOaJSx/q7Gzo+WKYCub0fKSYKYs0r8Rt3YwEqKxliZGKsS7dGLu6Q1kXN2CAXzupit
         X5EyEzbXBJ373RcKOqpB65dOJF14VorSrARze5xrQhxHIsv58zGMY7gnnE+wgm8SvPf2
         E+nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=doUMgXWCBDro9Kh7/VFGJHRKe2LzA8nUSOuOR4+/4Uc=;
        b=r2isDsd5lisVjhEVpcNfztqRd4r2dUnEQMIhGFIxk5QEEYKQUAYPWOC6mKn5j6j+ny
         9jY4zpOaRd093QMutMsvBwL/bVQEoxGfSSj7QjXqe+0InOHTERpT7nC1m4CsgTiC5EY0
         myRF/aYA61ollW/H0KRJhA5pMik/Zx1m0qI2pdGbrOgMnaWkL4nDF7yQuJZBRAEfH+lD
         9zen73T1ug4YndHooUPHQd6mwLvZYA2dUE45WA4ndSNWGSOVkQzlXlq9LwBipwG5EdqI
         FH44ZozYr3CVl1q9hV+tn+P2CpsEBA68t7xik/zwR/SIlUXJeMvsIgXseMgF2hbmjLA6
         Pvkg==
X-Gm-Message-State: APjAAAVMw5B5/wQBVxcnYA+5mYSkuIBbGAncMdG1Jch5YPD5QjFL+6uk
        Ak2OdbWTlpjKgtzpGzy+DZwgCTrYlj4=
X-Google-Smtp-Source: APXvYqwulUQEV7LBM3uoQ7aQqw94QWVlRDuu8kmL9cyVgJKr8JlP5O5TSOI391HAv+OJIp3HTlmoDA==
X-Received: by 2002:a65:4c8b:: with SMTP id m11mr1923011pgt.208.1578436141177;
        Tue, 07 Jan 2020 14:29:01 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id w123sm574654pfb.167.2020.01.07.14.29.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2020 14:29:00 -0800 (PST)
Subject: Re: io_uring and TRIM?
To:     Vitaliy Filippov <vitalif@yourcmc.ru>, io-uring@vger.kernel.org
References: <op.0d1lrpwy0ncgu9@localhost>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <79626b4d-9c48-0990-35f0-f06bb927a44c@kernel.dk>
Date:   Tue, 7 Jan 2020 15:28:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <op.0d1lrpwy0ncgu9@localhost>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/7/20 2:53 PM, Vitaliy Filippov wrote:
> Hi, do I understand it correctly that it's currently impossible to do
> TRIM  with io_uring?
> 
> I've seen ioctl operation support patches but they were really recent.
> Will they allow TRIM? When can we expect to see them merged in the
> kernel?

Right, there's currently no way to do that. But we could make it happen,
though.

> // io_uring is really cool by the way, thanks for the work :)

Thanks!

-- 
Jens Axboe

