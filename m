Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58676263609
	for <lists+io-uring@lfdr.de>; Wed,  9 Sep 2020 20:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbgIISat (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Sep 2020 14:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726976AbgIISar (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Sep 2020 14:30:47 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995B7C061755
        for <io-uring@vger.kernel.org>; Wed,  9 Sep 2020 11:30:47 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id u6so4235280iow.9
        for <io-uring@vger.kernel.org>; Wed, 09 Sep 2020 11:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=98xyvtYgbwa5J67c7RkI6GnQwliGFXe74W0JhOQBOmc=;
        b=Aai15vFl3dYqGw9K5b3xK4POAF5zorYpaKKRyIxIZqV4MkjapQJdc5WoBCxIdDvoQe
         7FdlRAedwzY1qpqwlJ5d+oVkEoZFtbyilOo5PeMvP4vfl//XjFD28AIWbmbRXihnb49x
         JbVoj7qo0eWkzJVqnZ3EfR9rqCRwG9dCMJoxkLi4ToOLHhfZC3SzjOM+82YB9SjmG1R5
         a33hxHQK4Io4do/ldHL0Nwp+Us6ESgUxv94eNJDwEE8kOAIZj98CWh42I5BQfrPOtm/D
         GfnSrPywZHKaSWgiqluDNEtHluhP8WGr1YnzmI21OdCOYBTano9T1NdzUMKvE3YznXEE
         +6HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=98xyvtYgbwa5J67c7RkI6GnQwliGFXe74W0JhOQBOmc=;
        b=b49cGFQikHPt1OpnpYf8+9JYTUTzyyPuEPlbCwEnE2/8wxWdUKsQnor3vt5O2n+fFU
         um2mwpoqLpbBSHpe7kYlo/7NxaUCa1k1c2gdy4y5JLZKOy50d2sqoxhquxd1QRa4lX8e
         A0li5lrcSa/XvQUmS2VMTeSRCtPtrmJnJFIxViVN9pAbIjudn5RDGD4naLXyD2x4Sobs
         qIEyow4WNMh/R88+jtAGPMLD9F59MSLIrkjuqqP1oA+9/06rN1JKlf05oy7EaALzp8AW
         YIeWSuxCB4os89ibVUJaTE8ZRgo21lmdKHx7oe9tw+XWNKuE4Y/viwNxE+6g6I0j2ENe
         5Kbw==
X-Gm-Message-State: AOAM53291BCWQzOV63pDHM3ZtV8+MdtS02qzaxR6aG9/an2CGU6onTnf
        uN9e6LjK316B26GxxuC9o5e76Q==
X-Google-Smtp-Source: ABdhPJzDQCDM7qsjK2rY35N17lqTgsC2hAs5QECTlf9biMd54YdHkaHJRtjNBTH3FQACUVf86OCMNw==
X-Received: by 2002:a05:6602:2f88:: with SMTP id u8mr4410307iow.175.1599676246841;
        Wed, 09 Sep 2020 11:30:46 -0700 (PDT)
Received: from [192.168.1.10] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id u9sm1501725iow.26.2020.09.09.11.30.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2020 11:30:46 -0700 (PDT)
Subject: Re: [PATCH for-next] io_uring: fix ctx refcounting in
 io_uring_enter()
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>, io-uring@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20200909151900.60321-1-sgarzare@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9080c3fa-a726-b664-f634-0ea7dfda80e0@kernel.dk>
Date:   Wed, 9 Sep 2020 12:30:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200909151900.60321-1-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/9/20 9:19 AM, Stefano Garzarella wrote:
> If the ring is disabled we don't decrease the 'ctx' refcount since
> we wrongly jump to 'out_fput' label.
> 
> Instead let's jump to 'out' label where we decrease the 'ctx' refcount.

Applied, thanks.

-- 
Jens Axboe

