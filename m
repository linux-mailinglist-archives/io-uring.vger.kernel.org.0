Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5258C145B35
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2020 18:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgAVRzD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jan 2020 12:55:03 -0500
Received: from mail-qt1-f176.google.com ([209.85.160.176]:44763 "EHLO
        mail-qt1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgAVRzD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jan 2020 12:55:03 -0500
Received: by mail-qt1-f176.google.com with SMTP id w8so211813qts.11
        for <io-uring@vger.kernel.org>; Wed, 22 Jan 2020 09:55:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=+DqMuHPUaB5GxazMEC4Gm2j+ebDvDQAMPEeQ0YEpSW0=;
        b=T+WSb3Bz4NYiQo8E6H5E0VUyvzAfRVMTyV4+1ouquSYmEEpNmtilPJ9XX1kRs606H+
         plYKeba+HmHeJjNIN2LsF3V4kE0rSkdf4iC9uo2uNDFyyzzKXXmwzh6PnTLt9icZ7ZTi
         Svny5hBYft8/dxbWEXk89Z6dvT22CzckbsJrkKtOSswvThktnvg6qz69pzZAWwufXfbT
         144dcjlrZNeFftff6B7nO/dVdaGr28a1wPYkJ6YyACmFfiLOD0BA1t6LF/rKP8alV5Ta
         1uDw2r5rADcFuwRIZWBMyYTkyQPBbxgdrU2obP21urH00VhVNFPaZG8EiLUDV9B5xfTv
         piog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=+DqMuHPUaB5GxazMEC4Gm2j+ebDvDQAMPEeQ0YEpSW0=;
        b=oq2HIFU7E5PKR3pvk39kX5P0VUq52F+L+hFNCc85XXmnEsE4exnSDmLKq2TMp3q6Ws
         4hUHEonfVgaDzBsbEqQkM/onbdf6l0Y4tY2HUoGfB3RxUIRbzNtnxoz6TUv+jqEH/ltT
         6gVWwBikN1nAldoVhEVojtWLTF5+XFIPV4FHm8U9hKOzy3azKiGKsdMna51vVY6Q6jv3
         O7Xm20zjIZg8Em/aLNDwMMeSMhlcUJ1dDpHF8tkvjmgaXiLx5hldzFEJLNVFkrvv2mk7
         B7gNot97hJixlOIFtZP5RGSTrhTfIDv6p7hTpqwM2Ccq0QG7qzU72uuIhk2VYHjqXL2H
         kGsA==
X-Gm-Message-State: APjAAAVTfDyUgUZdAbnykWsF0BQlyejSIRO0pawqFSvVhuSvk63pjRp3
        TMZJGoHFDtZwXC6NW5M58uffNwaHg5Yia1X+c86ecopiU8Dduyo=
X-Google-Smtp-Source: APXvYqzUk89hRK1p+f6MK0+mYYtWg0mOV69keyNxqKuPAW7JCRTMu2AdSAXmn78eIOoLqdlJCY4sF1IrzVlaR039X4g=
X-Received: by 2002:ac8:42c6:: with SMTP id g6mr6948695qtm.250.1579715702103;
 Wed, 22 Jan 2020 09:55:02 -0800 (PST)
MIME-Version: 1.0
References: <CADPKF+ew9UEcpmo-pwiVqiLS5SK2ZHd0ApOqhqG1+BfgBaK5MQ@mail.gmail.com>
 <1f98dcc3-165e-2318-7569-e380b5959de7@kernel.dk> <CADPKF+e3vzmfhYmGn1MSyjknMWQwCyi9NjWnzL23ADxAvbSNRw@mail.gmail.com>
 <77680e62-881d-5130-2d32-fc3cf5b9e065@kernel.dk> <366bcd60-f28b-4443-35d5-d8e7bfe7bba8@gmail.com>
In-Reply-To: <366bcd60-f28b-4443-35d5-d8e7bfe7bba8@gmail.com>
From:   Dmitry Sychov <dmitry.sychov@gmail.com>
Date:   Wed, 22 Jan 2020 20:54:30 +0300
Message-ID: <CADPKF+fN5fjRETntKVXsbUWhf5thaEyHHQ3cVgtZrLAgF3AUUg@mail.gmail.com>
Subject: Re: Waiting for requests completions from multiple threads
To:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> Just one thread gets completions (i.e. calls io_uring_enter()), and than distributes
> jobs to a thread pool.

Yep, I'am thinking along this lines - one thread is getting the state update
for multiple events and spreading it to waiting worker threads through
semaphore or else
I assume there is no protection of multiple threads waking up from
single event(one of the
epoll original problems which was fixed with a new flag).

The worker threads are free to submit new job requests directly into
the SQE though(without a proxy job list).
