Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9121D1DA442
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2020 00:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgESWH4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 May 2020 18:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgESWH4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 May 2020 18:07:56 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEBD3C061A0F
        for <io-uring@vger.kernel.org>; Tue, 19 May 2020 15:07:55 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ci21so267796pjb.3
        for <io-uring@vger.kernel.org>; Tue, 19 May 2020 15:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w30KZkRJxLlrRpM9jy6aSkV+Qi6QlWsQftc1SYTBEVs=;
        b=olklvNc/k9NAymQu0bDOSf9zKeMaYTOXqMRyZlzYSF8XFrD46oxBZZGtohvJ706sgY
         6yYIKb4our/JIxtv330rmrt313Zx1C65eov9N1JKleqtCeFvoBQP9jh6TrqNRW0PaApZ
         Az74D0yq6RcgnuZ3hJ467o3Ydf+xpef1CerUGcRMON05uxEnthEauOdjgZOvbrLhOfvb
         ghqj+71h3J4wdlRD11s6s8saLti9VdLJ5PxZTis8zHjHlkU6mWacPFjYF0NwvF7OA09B
         yh/VuHlS/cwCHEFvpCFsuIhlbVlu06q0GmLJD5WYUJBYD47TbOE+xYB3rHPIHn2G74nW
         aemQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w30KZkRJxLlrRpM9jy6aSkV+Qi6QlWsQftc1SYTBEVs=;
        b=SG9n8KNiR5VE1MaLyvHNUG8goGn8K+mPHUyQutDEtRclWpjQrTvngakryZ5rxncpfm
         DovL5JyWQWZXbI/ePByaCFOy0ygzfU0ffpJ87HchqhGfbDsJI760JPA5gWWfDk3snPec
         SGI4YlPnrzFcc8TcQ6SfQdUp1ov6mo0mw8ghgZm+kjj4dwZvj0VQMFqs2l5wsn/6iHWS
         jdihwGaNUvpXnUgpzM7L6uTnbYmY7avUigz2Xl5N2UbwBHOW+EjJBM1KY+EAsHVEMyvC
         4+GMsA1p2+v+tpaWjZiEYsbwbpnYcKsqnFdbt0vtwEoywJTynK4uxvLViJeUWZ0pRTIX
         0gzg==
X-Gm-Message-State: AOAM530i7veTtNWm3JvdtTot9X6ExASE54Ls4CfucW3JBzZtkXtS+o4s
        nrMMQYh6lbbzYqUoWxOEeklSUPlfpoE=
X-Google-Smtp-Source: ABdhPJxCaIfxtOTclkuLacQJhr6JZoiKUTEbIqCIrcQNLEl/uP4HtXGB6kuNLHzUDu0Ap9QjHweDEw==
X-Received: by 2002:a17:90b:3751:: with SMTP id ne17mr1652721pjb.114.1589926074947;
        Tue, 19 May 2020 15:07:54 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:14f4:acbd:a5d0:25ca? ([2605:e000:100e:8c61:14f4:acbd:a5d0:25ca])
        by smtp.gmail.com with ESMTPSA id p2sm347486pgh.25.2020.05.19.15.07.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 15:07:53 -0700 (PDT)
Subject: Re: [RFC 1/2] io_uring: don't use kiocb.private to store buf_index
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Cc:     io-uring@vger.kernel.org
References: <1589925170-48687-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1589925170-48687-2-git-send-email-bijan.mottahedeh@oracle.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6ce9f56d-d4eb-0db1-6ea3-166aed29807f@kernel.dk>
Date:   Tue, 19 May 2020 16:07:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1589925170-48687-2-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/19/20 3:52 PM, Bijan Mottahedeh wrote:
> kiocb.private is used in iomap_dio_rw() so store buf_index separately.

Hmm, that's no good, the owner of the iocb really should own ->private
as well.

The downside of this patch is that io_rw now spills into the next
cacheline, which propagates to io_kiocb as well. iocb has 4 bytes
of padding, but probably cleaner if we can stuff it into io_kiocb
instead. How about adding a u16 after opcode? There's a 2 byte
hole there, so it would not impact the size of io_kiocb.

-- 
Jens Axboe

