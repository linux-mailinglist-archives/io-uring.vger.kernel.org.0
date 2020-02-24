Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A88F916ADAF
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 18:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbgBXRiu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 12:38:50 -0500
Received: from mail-io1-f45.google.com ([209.85.166.45]:38694 "EHLO
        mail-io1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbgBXRiu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 12:38:50 -0500
Received: by mail-io1-f45.google.com with SMTP id s24so11122372iog.5
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 09:38:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:reply-to:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mwJznpw9bLTUrQh/py5fmEbtEuURhwLGUsWJdIaJUMM=;
        b=iotYhLRUJH9yTTKwIF5mF5tGvi4Oc1Z7Y+HkWBggTmHuG1fcDPTo4OiU/eh75mMZYj
         psc/hifpg2vo2YPdMva+rJ4io4ctcDbhQxycR7sdeaPimjZ5VSU7Glr9y0wYWJicvPLv
         J/Ca7cECj2vd3y8fwCqVUz2iG+b9J3BHYgcE2c0SgaRXOun4zswjeF/HA4PTG3sS3JB6
         zhgoSDKOjDdXCcUNZRgfdD7B0hw12o44ZfOgF1cWmcwUbSpFGLku/OAEGBknTDOMEkht
         vggKBlQTKrmoh5iE47PuhyBleBR5tsHxSJIJjX41Ttl5DqBk82+mWzrxPPZGD0DXC5E/
         OOtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:reply-to:references:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mwJznpw9bLTUrQh/py5fmEbtEuURhwLGUsWJdIaJUMM=;
        b=SYIFb2wg8WFtS+6ut02Tnf9qHjx3CDsNdWWOm5kvRIykg6tKBQh+aG0rqxfKkzvzho
         rd9ss0mmW4X36JSUm3zN7C45T5ZDfJk2rAi9tJIaGgL3GIjqW/QR4U8hhOpyqLmMSD41
         +Y6S50g8vAIkNjDtJNsRFNWmY1G4o0wnFJTTOLKb4e5wLZ2quZ9fC5esPhUpscnGUajl
         3JDpx5GPEriJ7MAh2DYoJl1qcMcOQ6y9aNmj8WyJBF+GEjURKeGprYux3cbswlGeiSfc
         i4a+S84Q1Z/OZLW6DG3lHKvrN4acDgA5qvwitvalY8e9DnlI8/gidB6B+j4yaWahDqQF
         1ZWg==
X-Gm-Message-State: APjAAAXB2mS9zj34NnEgNF2jiddYaLqrBgSNr7xPNFZG7Jhh5F1mp0qe
        q9pU2iGrNtTHD8JlfLK6b/xNVqxeoSU=
X-Google-Smtp-Source: APXvYqy4l1FkikrfZvqChtb6oZxlydiDdnlYR5l5gTxtrZ5+pbjRVZuKIlM6oSSQpkcPESIoHQV9Vw==
X-Received: by 2002:a02:c76d:: with SMTP id k13mr52115328jao.13.1582565929006;
        Mon, 24 Feb 2020 09:38:49 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id u10sm4539254ilq.1.2020.02.24.09.38.48
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 09:38:48 -0800 (PST)
Subject: Re:
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Reply-To: use@vger.kernel.org, polled@vger.kernel.org,
          async@vger.kernel.org, retry@vger.kernel.org
References: <20200224173733.16323-1-axboe@kernel.dk>
Message-ID: <3205d534-8f67-25e5-95c6-377fa852dd36@kernel.dk>
Date:   Mon, 24 Feb 2020 10:38:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200224173733.16323-1-axboe@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/24/20 10:37 AM, Jens Axboe wrote:
> Here's v3 of the poll async retry patchset. Changes since v2:
> 
> - Rebase on for-5.7/io_uring
> - Get rid of REQ_F_WORK bit
> - Improve the tracing additions
> - Fix linked_timeout case
> - Fully restore work from async task handler
> - Credentials now fixed
> - Fix task_works running from SQPOLL
> - Remove task cancellation stuff, we don't need it
> - fdinfo print improvements
> 
> I think this is getting pretty close to mergeable, I haven't found
> any issues with the test cases.

Gah, wrong directory, resending it. Ignore this thread.

-- 
Jens Axboe

