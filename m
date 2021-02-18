Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F99131F0DB
	for <lists+io-uring@lfdr.de>; Thu, 18 Feb 2021 21:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbhBRUOn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Feb 2021 15:14:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbhBRUNp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Feb 2021 15:13:45 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF120C0613D6
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 12:13:04 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id o38so1844854pgm.9
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 12:13:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=yzT+vh5CiweMgGUT3RH59ibrU8tO0w1UBZ4H/uL0Pt8=;
        b=mB+48+zmGDyUlZZjpX2e6HnxsooQ6fJyuSF70tSRYYm7tjnx28XmMftFUvwu2S1rdj
         GyEkn/C2QqMRmcn+AYkklX1s78LQt4ahvSbp9KKY8AfhMArOWRA/8eIQjnhbxnNpu52g
         k93zb3Xg6cSdDMSR5tTSwjvUh3kCKwAzXeMRF8rDwaiA+Pu4L2zsz72m2xSItrRm2+1t
         LvMSJTiEjccH6ELFg+NDipwv0Y2MCltH5fjYRgJXVnpBsufeHN/gY50IOzlRIUZaOdP3
         BtmsfPJ8KZh9TwulTCReePWJFU0rSKC3UDU7ToJwq02ojcd2Av9Lx5jp2P0GaIwx18Y/
         FFMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yzT+vh5CiweMgGUT3RH59ibrU8tO0w1UBZ4H/uL0Pt8=;
        b=ZG+K3wC5Wc/k9PQmyMbJsbYaUjmeT0r4CcN+q7bEFsMtn9OhauB6fVsO/VBgAIEHOM
         o8KaPa60Y2w0M7LtLCUzf3VFQ02nNzTYSFef6d+GA5wfRkn0b3RKzyhoCmpMdH2j65Ut
         L2RyIj+AuESEPZ2Vw9YcIO4pvbGRMKlofr/jsUh71pwZ6qG7l4c8le6GH4HOq/QUKRGg
         U2+ZMKseVRcd9EBjwB+7Ogfblsy9oZrMNtT9LaJWvgl0c48nK9sT5QIFl9Exvd8o8enI
         9pkq3+vrieNLQ2K4Zkf+qG3zPng9mzt75CeFWGp8CTGgZI54JOEOIhdnclKB8RobFjpO
         yn5w==
X-Gm-Message-State: AOAM530oG1CntvVWmi6BaveroXI3CJAehDvxzGtucDlVg2hRp5rwmUvT
        OZTOZE0Z/JCz5395x8bEzaCGtJSgGSXOsA==
X-Google-Smtp-Source: ABdhPJyp6wmMulyj8wlww0wLRtNdGXW5FePoB9bSBP1o+1YXXFMe5OG7b8aNeb+w4C11r18BqkZQNQ==
X-Received: by 2002:a05:6a00:1582:b029:1bc:fb40:4bd7 with SMTP id u2-20020a056a001582b02901bcfb404bd7mr6173766pfk.41.1613679184075;
        Thu, 18 Feb 2021 12:13:04 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 3sm6272912pjk.26.2021.02.18.12.13.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Feb 2021 12:13:03 -0800 (PST)
Subject: Re: [PATCH liburing] test: don't expect links to be partially
 executed
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <0b73a72d85384612118173d0a26609a728316b63.1613672934.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ca324fcc-8e5e-1692-6cb0-ee590870a6fa@kernel.dk>
Date:   Thu, 18 Feb 2021 13:13:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0b73a72d85384612118173d0a26609a728316b63.1613672934.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/18/21 11:30 AM, Pavel Begunkov wrote:
> When we link a buggy request, the whole link collected by that moment
> may be cancelled even before it got issued. Don't expect it to be
> partially executed.

Applied, thanks.

-- 
Jens Axboe

