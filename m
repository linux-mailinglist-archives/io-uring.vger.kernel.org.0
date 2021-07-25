Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A3A3D4F9A
	for <lists+io-uring@lfdr.de>; Sun, 25 Jul 2021 21:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbhGYSaP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Jul 2021 14:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbhGYS35 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Jul 2021 14:29:57 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D40C061764
        for <io-uring@vger.kernel.org>; Sun, 25 Jul 2021 12:10:25 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id a4-20020a17090aa504b0290176a0d2b67aso8141949pjq.2
        for <io-uring@vger.kernel.org>; Sun, 25 Jul 2021 12:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=kX0eYY9YjEaivkZX4gZmRWQoX5AVWchp0HevtnDPnVw=;
        b=Dur6eMDuTvAkBjxN5DFykUolJuJfOjcaoqcODAp46b1yil9KulA8uUGwZTDhk4nyFs
         CP1D3UTft8rGs8rkJxLhdckRscpRLbyfMoAWegJaJsIV+cjW1vphzhF0eoXSzy+3t50f
         HetlSuDMhM5u8/4GobkY72JHklydNFotcsZz8r2PhnhgTlQr1fISdiB+T0aY+vD67Nrl
         h7ZhGL5VyRL4evggJPgg26P498goeg31GDx6+zj3VZODxq/CnHKUci8dsbHRF8iz2RoI
         Y39ZFg0EhtjpJl30R0goupAxo9pG3/T69UAhYgh40xa5D7Em1/4QKOkJPC+fEDpVFafC
         woLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kX0eYY9YjEaivkZX4gZmRWQoX5AVWchp0HevtnDPnVw=;
        b=W7KFlDlfIjBf1lorg/G9hUaTqKOLJZMQ5ZKVj71U52R7o+KnLxLNtquS7Z3lcoGQeq
         bhzU7S0rT+T2XwUcjlgexwV1kLf46G8fLrKv8U4Alm/HS4RoLPcWoHZVDzlT3saxm3xa
         fcTcPIXivRDTGLEFONJQwKiTeUbvAmppMVY+5XOR2zmfrD87DnuvZ5haLHzHqkxZYPLO
         mMdHfkKtIMK0Vl8JQq7D6Uqqgo8nTO2xi2rtQGf3AWBjSTYbuDWH5f7lLD+KkdLtjB9h
         m61OMm2JYCvtjWHFBcabmJRsgSWzdRQ5Z0eFvMsbRGJl71HedqPGKkJk0yrEkNig/5Os
         O17A==
X-Gm-Message-State: AOAM5324QBWHh+84YNHIFQGkBwd97xXJx6tA+fTitAf3rYgXgp5zZ+YI
        7cbVnck0Dik0H1RpvZUla5YtAg==
X-Google-Smtp-Source: ABdhPJzpbjlw6cp7Z+jqoYrInoZDHFwmkxNjruW9JkW/6NtbfsfsTb5QFdOTVYq3kgTWS5DYGWbmzA==
X-Received: by 2002:a17:902:ec86:b029:129:ab4e:9ab2 with SMTP id x6-20020a170902ec86b0290129ab4e9ab2mr11638010plg.12.1627240224697;
        Sun, 25 Jul 2021 12:10:24 -0700 (PDT)
Received: from [192.168.1.187] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id o9sm42890179pfh.217.2021.07.25.12.10.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Jul 2021 12:10:24 -0700 (PDT)
Subject: Re: [PATCH io_uring backport to 5.13.y] io_uring: Fix race condition
 when sqp thread goes to sleep
To:     Olivier Langlois <olivier@trillion01.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, gregkh@linuxfoundation.org
References: <82a82077d8b02166482df754b1abb7c3fbc3c560.1627189961.git.olivier@trillion01.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ca9be2ad-711e-51a3-9c5d-9472a1fad625@kernel.dk>
Date:   Sun, 25 Jul 2021 13:10:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <82a82077d8b02166482df754b1abb7c3fbc3c560.1627189961.git.olivier@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/24/21 11:07 PM, Olivier Langlois wrote:
> [ Upstream commit 997135017716 ("io_uring: Fix race condition when sqp thread goes to sleep") ]
> 
> If an asynchronous completion happens before the task is preparing
> itself to wait and set its state to TASK_INTERRUPTIBLE, the completion
> will not wake up the sqp thread.

Looks good to me - Greg, would you mind queueing this one up?

-- 
Jens Axboe

