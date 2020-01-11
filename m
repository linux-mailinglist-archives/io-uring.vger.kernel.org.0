Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9684F1383EA
	for <lists+io-uring@lfdr.de>; Sun, 12 Jan 2020 00:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731635AbgAKXKQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Jan 2020 18:10:16 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40227 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731643AbgAKXKQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Jan 2020 18:10:16 -0500
Received: by mail-lf1-f66.google.com with SMTP id i23so4211899lfo.7
        for <io-uring@vger.kernel.org>; Sat, 11 Jan 2020 15:10:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JGwjCwjrE/FFSrouiscxDxwOQNaut4YCL+E/ntxvkLk=;
        b=ek53wvr+YlCxw4RZH/KIJwvKFAOlTWk3Q7bvWshJrNCGX222zu7pTWxsYY91YLogH/
         TsFuUwwbexBeA//p5cedB1CuaX0tBBs8pYf1wC0Qlu0/+0rg5b1lW9FKmbhFsZsnRA8c
         Mzlh3FYcebzKZRTE/KYT+Glr1te9v3V+8yY8MLNdmPItYU0QxNH0URRcrnuyOEjD4+No
         0IsIUoEs7lKmZk775eGat37EwEDHtqCjoorJ1bOLEaw05T6WBYWuzx+L3cw1X2CqKB9z
         TtWTRysDG/homUoSOQ3Jykbs5VLoXZuobbfFlANkWWgpoff1XLD1obxSxO2WpkdU6hvC
         zUuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JGwjCwjrE/FFSrouiscxDxwOQNaut4YCL+E/ntxvkLk=;
        b=stIZLOdRKI7WsE4WuxqF9kckxInT/923XBzghvG7LHTqLwhzkVJi0YX0NWOh2Rlaus
         PTFVzyO50HQ2bk6u1LYkAjmBwz30ogqIf9VZL1W5syAz1JvdLpaSA8PfnkY7WQUoQhsU
         PXvk/MWmR7njXwLeXVKVhUEclDoSI9m7k+PdTDayrx4WCd4DkGNLN7wkyK/RXKWNzoUR
         WUKrBEsoQ67/O/hpFogfdXsohflFNcPGx6hdn2mbJRQdFmP1sVCG1fk1yGvem18LDKA8
         HI3MGG1V+C0AKFN6lCzcZ1kRorTTLHSknaBow9qr/0n2CTW1JQRRC3R/lzKSBACpWWp0
         fbog==
X-Gm-Message-State: APjAAAVvjulWUXqIJQyXrr7J1xJFYnYXO4Uhiu6k29165rH+5IS6QCgY
        nQvhIhHd8If7YzmtklNBAddLhg==
X-Google-Smtp-Source: APXvYqyVLZJrMH2WTpP/Pm2kwNmX9kpoZaifgqplxgcVA8vntvnh6xWYR00UDtyESJEmJEnudgqL7Q==
X-Received: by 2002:a19:40d8:: with SMTP id n207mr6110718lfa.4.1578784213877;
        Sat, 11 Jan 2020 15:10:13 -0800 (PST)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id t9sm3324524lfl.51.2020.01.11.15.10.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jan 2020 15:10:13 -0800 (PST)
Received: by box.localdomain (Postfix, from userid 1000)
        id 9455B10036D; Sun, 12 Jan 2020 02:10:14 +0300 (+03)
Date:   Sun, 12 Jan 2020 02:10:14 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 3/3] io_uring: add IORING_OP_MADVISE
Message-ID: <20200111231014.bmpxdg2juw3mxiwr@box>
References: <20200110154739.2119-1-axboe@kernel.dk>
 <20200110154739.2119-4-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110154739.2119-4-axboe@kernel.dk>
User-Agent: NeoMutt/20180716
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jan 10, 2020 at 08:47:39AM -0700, Jens Axboe wrote:
> This adds support for doing madvise(2) through io_uring. We assume that
> any operation can block, and hence punt everything async. This could be
> improved, but hard to make bullet proof. The async punt ensures it's
> safe.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

How capability checks work with io_uring?

MADV_HWPOISON requires CAP_SYS_ADMIN and I just want to make sure it will
not open a way around.

-- 
 Kirill A. Shutemov
