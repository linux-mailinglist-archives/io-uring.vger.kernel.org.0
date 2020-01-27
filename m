Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8E8714A95C
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2020 19:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgA0SAh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jan 2020 13:00:37 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:51815 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725828AbgA0SAg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jan 2020 13:00:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580148035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LISUUc5mSbwq4OOhAuP2n+5DZiLWcPcw5gQzbhBN3r0=;
        b=RQRS9wEUxc+4pyuat24bvH+M62RR1bvIeqphh0phXj1dtjfaU1GOD0bnY/HEZYPyrfWkz8
        dwMpTTNIUDx30haOWICziJmTVjXV8SWJZsBxX3hd4rlx988PPqkueZXHYMTU9Bm/JueFHG
        jC7IkOqVBHjra3liav6s3TmwROii1Ok=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-bwB6qULOMO2gytP2iD1ajw-1; Mon, 27 Jan 2020 13:00:33 -0500
X-MC-Unique: bwB6qULOMO2gytP2iD1ajw-1
Received: by mail-wm1-f72.google.com with SMTP id p26so1720093wmg.5
        for <io-uring@vger.kernel.org>; Mon, 27 Jan 2020 10:00:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LISUUc5mSbwq4OOhAuP2n+5DZiLWcPcw5gQzbhBN3r0=;
        b=jUMzefznsr9q+Mmf/LJi/Kji1ENvfHTr9a8IKfgnjwgoMrL8dC7I6GjZVx1z5l9E05
         /KvAGkCl9fFeN5k4x8fFkw4LIMMjaTK8ubwplZrIlQc/G6rP7njWlY9wF/9tKK0s5Srb
         1M6/WXBfbGzVgOo7SNKF5xqHm/4E3Z7kDsyVJ6OzL9SPND7z4HLoRugVFgbK5GWYoCMF
         M/aUSLFv6CX/TAtuLLRH5lyDtPEEONEW28238uiUDu8HlutxMDWFZ+WOD/pbHsrTgIs0
         jpY9xnIwqc8fQM1mcUs+6imhjAMoF6KrjbXkvqkfMfYzbvmhCMhNCKp59oX+4G+9UW8F
         lWdQ==
X-Gm-Message-State: APjAAAVxKDT2mqg5d41bjpHw0go5MRPj19uO6nD2PuaygRHFX5GanBB4
        psunl9sskL6voxiGH4PWqu87yCz9DHYoApfjfeUqZSgeSavS6tZmUhHZVRcLZFPK5LrlfQVQ20v
        Ow7ToUlFfUiMp5APhSDE=
X-Received: by 2002:a05:6000:11c6:: with SMTP id i6mr24247862wrx.178.1580148032354;
        Mon, 27 Jan 2020 10:00:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqydXL8Hy6hmc2+0FfdGyYbjp+tHmBYor3OXZuBag9Hl+JQXNDQY2Irhah3wQr6DKLU4A9G9yQ==
X-Received: by 2002:a05:6000:11c6:: with SMTP id i6mr24247828wrx.178.1580148031996;
        Mon, 27 Jan 2020 10:00:31 -0800 (PST)
Received: from steredhat ([80.188.125.198])
        by smtp.gmail.com with ESMTPSA id u7sm19732499wmj.3.2020.01.27.10.00.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 10:00:31 -0800 (PST)
Date:   Mon, 27 Jan 2020 19:00:28 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH liburing 0/1] test: add epoll test case
Message-ID: <20200127180028.f7s5xhhizii3dsnr@steredhat>
References: <20200127161701.153625-1-sgarzare@redhat.com>
 <d409ad33-2122-9500-51f4-37e9748f1d73@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d409ad33-2122-9500-51f4-37e9748f1d73@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jan 27, 2020 at 09:26:41AM -0700, Jens Axboe wrote:
> On 1/27/20 9:17 AM, Stefano Garzarella wrote:
> > Hi Jens,
> > I wrote the test case for epoll.
> > 
> > Since it fails also without sqpoll (Linux 5.4.13-201.fc31.x86_64),
> > can you take a look to understand if the test is wrong?
> > 
> > Tomorrow I'll travel, but on Wednesday I'll try this test with the patch
> > that I sent and also with the upstream kernel.
> 
> I'll take a look, but your patches are coming through garbled and don't
> apply.

Weird, I'm using git-publish as usual. I tried to download the patch
received from the ML, and I tried to reapply and it seams to work here.

Which kind of issue do you have? (just to fix my setup)

Anyway I pushed my tree here:
    https://github.com/stefano-garzarella/liburing.git epoll

