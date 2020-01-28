Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5166414AD17
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2020 01:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgA1AUM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jan 2020 19:20:12 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:55435 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgA1AUM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jan 2020 19:20:12 -0500
Received: by mail-pj1-f65.google.com with SMTP id d5so207767pjz.5
        for <io-uring@vger.kernel.org>; Mon, 27 Jan 2020 16:20:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=3xjEjiT9BNM1g2BaFpy1wqCXnDygl40udCdM6qC7ofI=;
        b=vOp+qR1sdyLY0xE06UhPGoK3Npjzwqz6jeb4qXxP48mFNEqQv3CLIigYJKDmYdChVr
         6V7Jq01ofvw6b2NOnuDpHsDpIgxd3/UmkAq5tuyx0OZSrN6NMhl9G4jniCa6zvM0w8XE
         qiDdRPnxvjpq1WOoXTk+3XzPfr65f7EvLQd8sfQirs9S8SxUsC2Y6WyXuOjPAFshvkuQ
         w99t7uVpwgaMSyQOT2OKdzPcns8KH+gADfackdi5L+e7axIftAnj8yrEBezYknsK0mTG
         6q7RgR2NbCxgtZZfkX6j4Lw46HrFQVOtZ9h96QBhUL4O1cfvWaA5r889WCUTYButJcy6
         ubzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3xjEjiT9BNM1g2BaFpy1wqCXnDygl40udCdM6qC7ofI=;
        b=C/gLd0iZ6yvqILSKSeZ/B3Kr/DB0y78PegO7hM5fsZXPSwrTbcEOt8NzvCqUPsIHHf
         k+pJcBdE/L2AyUJGb29fgt4FjzKzIugJmEDoAtz5kn7QeO6rXukib0I+VPbYkTk0xNbI
         5u/PeMRt2h2Pj53dxfKM48wgNR03STiZKzPciYLieRH3nbXtWUTtxprC0xas1g4O7MOF
         ope82scYDwCOcD41OCPoNknOpj5woolUiu/4J7F4El5qnju/+Nx1Fa2cvvfR0RhPXwP5
         jv56cGHj7/sKeyTz6uKle6THXhcfxOvic8LfH6hhZrxFYNsDG0JH1X2HVwsch9sO/mhY
         x5Gw==
X-Gm-Message-State: APjAAAUBOs8UsnfSR51GnvsuriER/AUSSgnLeQTEaQkbC/wb6yt0+sMR
        +1ppPvG2PK3RweVhMwQYODdaDw==
X-Google-Smtp-Source: APXvYqx1cfjZh64/eBQbZ20GVGuhA7GXCp2l/6+i5nhjLmxjaPXhIZ+9uBXk3LiWpaloxJUe72DLZg==
X-Received: by 2002:a17:902:4a:: with SMTP id 68mr20690843pla.245.1580170811783;
        Mon, 27 Jan 2020 16:20:11 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id u3sm226476pjv.32.2020.01.27.16.20.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2020 16:20:11 -0800 (PST)
Subject: Re: [PATCH v2 1/2] io-wq: allow grabbing existing io-wq
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1580170474.git.asml.silence@gmail.com>
 <af01e0ca2dcab907bc865a5ecdc0317c00bb059a.1580170474.git.asml.silence@gmail.com>
 <24432662-f6a5-99ef-2a73-e0917ecc8b07@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6fa832c8-75e3-78ff-1d8d-592d755744fc@kernel.dk>
Date:   Mon, 27 Jan 2020 17:20:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <24432662-f6a5-99ef-2a73-e0917ecc8b07@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/27/20 5:18 PM, Pavel Begunkov wrote:
> On 28/01/2020 03:15, Pavel Begunkov wrote:
>> If the id and user/creds match, return an existing io_wq if we can safely
>> grab a reference to it.
> 
> Missed the outdated comment. Apparently, it's too late for continue with it today.

I'll fix it up, testing it now.

-- 
Jens Axboe

