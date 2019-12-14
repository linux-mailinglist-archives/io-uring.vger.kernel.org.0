Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B18EA11F38C
	for <lists+io-uring@lfdr.de>; Sat, 14 Dec 2019 19:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbfLNSob (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 Dec 2019 13:44:31 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45670 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbfLNSoa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 Dec 2019 13:44:30 -0500
Received: by mail-pf1-f194.google.com with SMTP id 2so3273480pfg.12
        for <io-uring@vger.kernel.org>; Sat, 14 Dec 2019 10:44:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ZagUwuvSKP3tacaAxIxfNOPzP54F5fRDSaAl/1LvXpY=;
        b=ei9G4MBw+PkgkDIDWnJCr8QRpRVoEKxv4Ix6ggoKxiXrCFQlGnPFMRIvKdB85YMZwp
         J3v+wNaqpAkl23e2HmOFaWQ7fEHLcxmOPVaNfZ3xUielVVLhNLxWxtYz7NkWdteo1Cyf
         HUZ9Tm29djGaou8wgGKsmtf+Dfs7p7+/ubJAAdEb6FPt9q7jTgzGb0OPtPj8L49b3vVa
         M8mD4lqseYB9jbjRTv7FEIDpF+AK0ibRyDa48iTEJEUD3Td+k2CxRCdzBYnMD7BgYwnZ
         IThEPQ+JhpRj5R11F++6FchWM0SWMg6l7np8Q4vqJKT/LauNOGTUWT6KT/y96lN2pmUE
         Rh/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZagUwuvSKP3tacaAxIxfNOPzP54F5fRDSaAl/1LvXpY=;
        b=Ac5ik4k3sFwY5rRthNVmMz/vMw+NSjLIux19MdFmRbLA3wUqHEGiN2unwoCPFz7c9R
         yrC9Y1QX7HilulDpy9jsAhsSzwJXXJZo/bocc2JWvPspyV5jswqOz4ube3B4cf0S3WPG
         Ch9mPWTh4MuUofHuPMcohFA1ymfWQTDsGNsgtqKRLhcjcH5979g7sKVV3qyCZbaL+OIm
         GulZesBxmniyDTZxV12DsXSC4ABr4JPXHLa4JAx/6PmBrX+O4lzsaIyqk2fV1EaRQtHI
         9tilyQm7zI26wRhdImOqPoNKvmMJBGpITQSfLg/FIYniPlJGfNVTTTcyexQdnpZZRafB
         PMBQ==
X-Gm-Message-State: APjAAAVYEOiOd5X+BLgTWKb2+uvKWlO7dkuqiFzKYfY6CXuaVJaNduOo
        yhNwucQcT3vVSL57ZVt2qeMA5UOs6N0RXg==
X-Google-Smtp-Source: APXvYqx2A91RJqu7o4dkqnSETWSBiQ+h0zmugfZi0DTEXnjMht4iLs+JJajWDVBr3rVmqQVMEVN5+A==
X-Received: by 2002:a63:1e5c:: with SMTP id p28mr7068869pgm.235.1576349069784;
        Sat, 14 Dec 2019 10:44:29 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id b129sm16006410pfb.147.2019.12.14.10.44.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Dec 2019 10:44:28 -0800 (PST)
Subject: Re: [PATCH] io_uring: Fix stale comment and a few typos.
To:     Brian Gianforcaro <b.gianfo@gmail.com>, io-uring@vger.kernel.org
References: <20191213110950.124702-1-b.gianfo@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e7ae2f22-5c4a-2392-2715-518e29737007@kernel.dk>
Date:   Sat, 14 Dec 2019 11:44:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191213110950.124702-1-b.gianfo@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/13/19 4:09 AM, Brian Gianforcaro wrote:
> - Fix a few typos found while reading the code.
> 
> - Fix stale io_get_sqring comment referencing s->sqe,
>   the 's' parameter was renamed to 'req', but the
>   comment still holds.

Applied, thanks.

-- 
Jens Axboe

