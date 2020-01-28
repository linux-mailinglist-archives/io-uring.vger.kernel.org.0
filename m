Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7962E14C15A
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2020 21:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgA1UEe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jan 2020 15:04:34 -0500
Received: from mail-io1-f48.google.com ([209.85.166.48]:44602 "EHLO
        mail-io1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgA1UEe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jan 2020 15:04:34 -0500
Received: by mail-io1-f48.google.com with SMTP id e7so15836941iof.11
        for <io-uring@vger.kernel.org>; Tue, 28 Jan 2020 12:04:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vddfp0PbrX4PW/A1Mqvi8srsFEuPF2XDyAWEjCxTh2k=;
        b=ENuHELy6ViQg2MjTLKxdy0jThc5QeNPOoQwP2tBdY3c8F+q0eW/F5V9HJfkBakNaNV
         jfwg0YNw2vbuMPiRbyTF/CR83vOeD5yfKlN6CdvYftx8JiDXroK4gv6f0RaOhh/o0J9f
         NZDWqlFa35PBXD92DJjQft6c5JE3RFRMemo+/jytTS/UxR2pHwx5tnu1EIAi13V9O5Z3
         ORIvo7ulwoXkEz7yF/XaWlnNEhtegl328UNxRhlXZV5nzL2dL3VtJ/QhTL/bfhC6Ljxu
         0TdCW0jpqdVXEz+/Ri4OVH5yPzrp8BZvk0Sn2l5hKRyisIzNL4iPje4h8l++R31sPC20
         wZrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vddfp0PbrX4PW/A1Mqvi8srsFEuPF2XDyAWEjCxTh2k=;
        b=nkXL6x/Wd2wv25zxnor5VZdVO3eNB+hVp4BN37/EUGSxAjshXxqePfY9A/+D37w8xA
         zs1/Ny25ocTy9oZVe3dazjIrugsIy4yyYNq4J2921WUx+h6TXi0dcE/qxGDYZyaIGd7a
         FIroqKcw/LDoI4EASpAFOjPnU7WapASK8+U/N29ocS2e7sjQw6kFKsxTC/EaI5JZ64eg
         vFXIa0Iu891fLtfM2pLbCPuL/Kb2rcTpWI4n0W8tbhxqj0CqSrVuQNXMxf+LM1Xlzvua
         lzdDpU1NMnyR68MOvPF9s+43+ltriXuVwNrvxzI+fIrr9ARycb2PUVy7iqiy90bRRkCy
         fOPg==
X-Gm-Message-State: APjAAAWGUVjAkgpNtFBODo9P8eASRropVHTzC+ti39mWhuvfPTQTQGHC
        yTxvZoaz2gDs1CVB6ezIbYJ7N+vlhNM=
X-Google-Smtp-Source: APXvYqz5ciwG0gPyaQUDltVRK9IVglCDUBy3Jpl37nxADs0sUa5PFtrNozVFJXq8o9Vp8JT2qGuRfw==
X-Received: by 2002:a02:cc59:: with SMTP id i25mr13905690jaq.78.1580241873734;
        Tue, 28 Jan 2020 12:04:33 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e23sm2035213ild.37.2020.01.28.12.04.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2020 12:04:33 -0800 (PST)
Subject: Re: [GIT PULL] io_uring changes for 5.6-rc
From:   Jens Axboe <axboe@kernel.dk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <edc14d52-b3d7-9860-097a-357164150e85@kernel.dk>
Message-ID: <884006c1-facc-0b9c-597a-61f3f6bd85db@kernel.dk>
Date:   Tue, 28 Jan 2020 13:04:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <edc14d52-b3d7-9860-097a-357164150e85@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/27/20 12:59 PM, Jens Axboe wrote:
> Hi Linus,
> 
> Here are the io_uring changes for 5.6. Note that this is sitting on top
> of Al's work.openat2 branch, and was rebased about a week ago as Al
> rebased that. So consider this a pre-pull request, ready to go as soon
> as you've pulled the work.openat2 stuff from Al.

We changed the sibling ring support somewhat, so I pruned this tag. I'll
re-send this pull request in a few days.

-- 
Jens Axboe

