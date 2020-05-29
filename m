Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36AA01E800E
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2020 16:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgE2OUD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 May 2020 10:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726816AbgE2OUD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 May 2020 10:20:03 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A58C03E969
        for <io-uring@vger.kernel.org>; Fri, 29 May 2020 07:20:03 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 124so1547314pgi.9
        for <io-uring@vger.kernel.org>; Fri, 29 May 2020 07:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vkEBtJNath11cZhPEQ+J/gMUTCbLhM6n6v2IJ68OXjs=;
        b=AYIx5q02AI2raQqjDWo0poLgXqqxDqP4HF6s8VDmemaiJmNdg1SNmfvvpa04MgZy4J
         vaEAFi2bOJRJn3ludmJ/PqKNfEa41FuVu6ZhmIdR4WFkR841c/qRMzeAuoPeKiZKMjHF
         MGixMIH0WmqcG1NQYYlQ2VL3ONWWAp0aPVSupqHGESO3Zt0Lyl4ljSBbn8a1I5wBfdDr
         ZS/Zz79dkmRBlXH9NfTJRxmZ20S2DFMtt08Sll0qCNPAAMiTobtpRdn70QE/nMZqpjpf
         4Y4pMdraN/sPyV1H1ggSDbpuWCJODgQygTH5cKDyuseEUBIseFHHUBwOppAfynmVvX/b
         JMXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vkEBtJNath11cZhPEQ+J/gMUTCbLhM6n6v2IJ68OXjs=;
        b=hNahAMPmAy2/Hdh3gWiXG/MsDJxUi1SwON+wEVvhYq1SbiC98dalm30TC0JPWDJ6Js
         3dBSz23ZdVZ8+yEfJxDygKGn8bxMyY5PZeY0Y0G/JdYz0E8CccZTqezslx5vg5LT8cRe
         D9ox3Hb3Z17i6ppeufrLeBkDpA3qw+uBKHx1gNDV8OBqSUMCiTWdJhDhId3aCOAUmxhg
         CPJK2BEIe0Nq6t1oAYFcMxhhecagh159KWX1eK6Ba4c5JBBjgumImgufoTtX6rIw6NNJ
         kqyi2hzEa+w8XZcHemwZz2Itm/yvhFhjHZ0WVt4WP6XRYnsIOoOV8Nhv9NIyLhudk40r
         3y0A==
X-Gm-Message-State: AOAM5338BGyU8PdZOcCHkES2OPGymhPyypq6OVArIuP1/4ksPANljhxX
        d01DmR3ycjIChIjbKzRmtgo7z6Dn3JP47Q==
X-Google-Smtp-Source: ABdhPJy1jBRDr/P7jbL5+gtrU2rlzJaOjvtwhr0uVHKmn9gYEw8V7sHZL/AUBenPv8cL0xKJtp+0VA==
X-Received: by 2002:a62:1b87:: with SMTP id b129mr8790375pfb.162.1590762002907;
        Fri, 29 May 2020 07:20:02 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w190sm7355041pfw.35.2020.05.29.07.20.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 07:20:02 -0700 (PDT)
Subject: Re: [PATCH] io_uring: don't set REQ_F_NOWAIT for regular files opend
 O_NONBLOCK
To:     Jiufei Xue <jiufei.xue@linux.alibaba.com>, io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <1590736708-99812-1-git-send-email-jiufei.xue@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <df16e843-6b02-e51f-c99d-9886ead20943@kernel.dk>
Date:   Fri, 29 May 2020 08:20:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1590736708-99812-1-git-send-email-jiufei.xue@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/29/20 1:18 AM, Jiufei Xue wrote:
> When read from a regular file that was opened O_NONBLOCK, it will
> return EAGAIN if the page is not cached, which is not expected and
> fails the application.
> 
> Applications written before expect that the open flag O_NONBLOCK has
> no effect on a regular file.
> 
> Fix this by not setting REQ_F_NOWAIT for regular files.

Agree, this also matches what we do for sockets. You need to update
the comment as well, though.

-- 
Jens Axboe

