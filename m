Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B69F13B444
	for <lists+io-uring@lfdr.de>; Tue, 14 Jan 2020 22:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbgANV1o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jan 2020 16:27:44 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:44030 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgANV1o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jan 2020 16:27:44 -0500
Received: by mail-io1-f68.google.com with SMTP id n21so15486763ioo.10
        for <io-uring@vger.kernel.org>; Tue, 14 Jan 2020 13:27:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=PNvthDK3XPKoyLuqFvFlayImRnOtyUVVw2nLWW5ztoA=;
        b=HDJhwoUgoulliYTpzn50bLaTQZBGuvxwx3B95UxPd88s/KfhnBU95pLMv+80DrTmI5
         +A+TfVKPLENsMLvsDgLqQIeM6to3I/W/b8vx39NEozsGVDC4xOJjDF1v+u3HCQRODAdb
         Z4mRYd863BWi/JlShS/MifC4OskrqsI8ihH0xB7X2OVtfM3ZPKfFoiHnGh8g+/JX7pnL
         SwR/80cWiHCd3eK2y4E2cLJrmopEVDvvx31UJZkEjfJ+3l1JzPK7DLbfV9Cf5bIVbhqn
         ceYvA+n/xC9DLwROqdZtBCftI+yeHpHpEZ13ZOLqTNO2yhJoh+nWIjtDQrpEhRyo1v/7
         /Phg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PNvthDK3XPKoyLuqFvFlayImRnOtyUVVw2nLWW5ztoA=;
        b=R4UVrZd4/Rmsf1E2sr61UvYW/egoebIAe913IWxoEzRMk61xLMbgbYTijcF4wRTvA5
         BTdNgw1tLUtlAt3EdqXr+60ocwuBOcE4XaqxtA1pqtaGR1IG6HDTzts5cIBmXnGCSECi
         Ailm7e0/hbazLGQTehwrmAUxChX+kjBnUnPVXcgr00+JK3x49W4m7NBeGlMHBmLDcVFR
         yPsY7o2Hyp/YnuICQnHJnFUQ0grKdll0iAlQYx9M0vlEdb8Cl/qksfryQCfGPY3rft39
         TP70g3+hWelmyE2QUmFB54JefSo07EG5iJtEywB+WchfCilDHCUgfIH33SmslIiZFxZn
         P9uA==
X-Gm-Message-State: APjAAAXcNxMMKUin3oXhPSqCrtKlzA6kOLn8GoZ4Uts/TdLE4QVN7Gz6
        VwvUDf+y5MF8GyWWpknAp5DYlzLoES8=
X-Google-Smtp-Source: APXvYqw05dd45wEH107bSyFlY5J6BT8b84pQiAm2zNa8VUDtW2R0nn5xoeH2yX9RFB1yBUdaT+9GlQ==
X-Received: by 2002:a5e:8703:: with SMTP id y3mr18432756ioj.308.1579037262922;
        Tue, 14 Jan 2020 13:27:42 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e184sm3710652iof.77.2020.01.14.13.27.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2020 13:27:42 -0800 (PST)
Subject: Re: [PATCH] fio: Use fixed opcodes for pre-mapped buffers
To:     Keith Busch <kbusch@kernel.org>, io-uring@vger.kernel.org
References: <20200114212424.8067-1-kbusch@kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5fbb0b20-1464-01e7-34f1-023caa139030@kernel.dk>
Date:   Tue, 14 Jan 2020 14:27:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200114212424.8067-1-kbusch@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/14/20 2:24 PM, Keith Busch wrote:
> Use the correct opcode when for reads and writes using the fixedbuf
> option, otherwise EINVAL errors will be returned to these requests.

Oops, thanks for fixing!

-- 
Jens Axboe

