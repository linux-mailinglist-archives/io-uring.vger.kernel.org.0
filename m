Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C754C14CB83
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2020 14:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbgA2NjT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jan 2020 08:39:19 -0500
Received: from mail-pj1-f44.google.com ([209.85.216.44]:51672 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgA2NjS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jan 2020 08:39:18 -0500
Received: by mail-pj1-f44.google.com with SMTP id fa20so2577407pjb.1
        for <io-uring@vger.kernel.org>; Wed, 29 Jan 2020 05:39:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=jRw4gHj3o+0fDg3wZL+MId/7a4nIQ2wDAMiYdbQUCIE=;
        b=MNWayklz5DOaPLQuHOF6vvFj3L/UpWZ8cJxmLJMaJ2B3hV7J4/9PyCQIcZCUniepHJ
         BC0JgUyyh2JTo+rYIfijyJo2csqrMSk1NgZBZKNj4JoFSTpCCSnmwXp9hTjd+enGGYYu
         dqkx50Nhvd9ugjHLtwOvHFXIyfMxuo4IIZXDTX3odQaI4VhjtqQ0KDXjmpOIgQI0s3hr
         xAA2Ua3U6sFfwiAYFP5TCXJaRWNEfK66QIqkG5sJ8mWFZaC+q0zLWJ9jTDKzIu6P2dQd
         3iqpEuVIMD13B9AWJ3jDbkj6Jl8DUhBR49cpjtsK2RCtSD+xdC3tcuaZn6yy6Rmb6xzQ
         ExQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jRw4gHj3o+0fDg3wZL+MId/7a4nIQ2wDAMiYdbQUCIE=;
        b=dWOWztoyOCMPdiABm86prJcI4UX6LYs9EIJU1BzB1Vqvg31WwhjsgBCoLaoYrvFE8+
         /ILbOA6Y4yFt1loHpKTyOAQKEtG2fQ/wtJhQlIPkxYAfJOJQFS/XC5j+we1SP/2TtR/b
         n3B6BBC2KAxPL/lxaFlwep4wG7MlxtxK0om6Sp8q8s/ilKN0WX5b9cgxiJbp+n+03R3Q
         v6YU+a9ZCxOFDpylxKuKLYWEs09d01qxeFKXvATb4Y4vei/nWyntsb+8VKXrY+IOmbKY
         qq2wM7cF0YuPYeS6WM04QzDQ2EumWK3FZ7RfS/hbnz7B5LgwEAihT0pmzgaxLnv5RwJQ
         MrQA==
X-Gm-Message-State: APjAAAVFAUwB8lXP9LVJ+ygoRjcUpZeg8W6y9vKbb9cHbmmq2aFyeqsw
        sWrRXCYkfoMp0uGkDlr8Dca2GQ==
X-Google-Smtp-Source: APXvYqyPhfTyC7VNpA0L1MnRS7VkitmsDY5CbseGZBhvbp+Wxs1WEbNLbRh9ExN3O88DCJIhHovfdQ==
X-Received: by 2002:a17:90a:c708:: with SMTP id o8mr11397427pjt.104.1580305157936;
        Wed, 29 Jan 2020 05:39:17 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id i68sm2972265pfe.173.2020.01.29.05.39.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2020 05:39:17 -0800 (PST)
Subject: Re: [PATCH] io-wq: use put instead of revert creds
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <c79bab7a6bd174f32121c9508390264bff9950ca.1580292613.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <044f452e-76ab-c555-9dce-3c7a711d3c5e@kernel.dk>
Date:   Wed, 29 Jan 2020 06:39:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <c79bab7a6bd174f32121c9508390264bff9950ca.1580292613.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/29/20 3:10 AM, Pavel Begunkov wrote:
> There is no need to publish creds twice in io_wq_switch_creds() (in
> revert_creds() and override_creds()). Just do override_creds() and
> put_creds() if needed.

Thanks, looks good. Applied.

-- 
Jens Axboe

