Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2B66168313
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2020 17:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgBUQQi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Feb 2020 11:16:38 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:36144 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727095AbgBUQQi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Feb 2020 11:16:38 -0500
Received: by mail-pj1-f68.google.com with SMTP id gv17so956600pjb.1
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2020 08:16:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/D/bCVh04fEfVjE3l+u65ysQqtalkQRAJeGslkh2Jlk=;
        b=v5lA5xSH7LDA9vQ/4iVjZB56ndgIrMqEWa+q30hZWOaB/8Yk/iSra60oBQabsvw47c
         ysRjVU22aBNfvLA3yMfqeAAHfjgG9NR7ExBkYgXCJ9AbqsALQs2aiVR0mWyqOujxdrPB
         B4G/HL+CN0NmAEbRK0fxR8XnK1fPc40icdwd0PThc13FaZYozszyViIB3x3Hv1sJNllp
         hZlOSVd/Kgm8e9y5V8hPpkz7XVdHbcfYsNDONcj2W0q/c20z72Yyl4WC9CiYJ+5xSqjn
         iW1h6CaFaBDi3UWsNS1fPMgevOdnKbT2199lDkFRcATJelHZPTJN6Pb7vQa2Iott0OC0
         0z4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/D/bCVh04fEfVjE3l+u65ysQqtalkQRAJeGslkh2Jlk=;
        b=oXY8A7jNxE67euEZEAHnn59YvdbdrvIW5oZGQIOHnz2yG7m+s8jxqBs+E1xWdBk0As
         MYHxkAYoo4V2ye5e6ioZvTvH3neEclvX8S/VDM6xc0AxWFl22zfgLPXrc3wH/R+wT5T2
         eCnCvQL/I5BkRZANZem3NsFL9FSOzxfmY2XAjaCFOgwjA8eoCYXiTAf/Wi5M1OspA7m+
         f6Nbk6dbpQj4Yp5VdbvvxHpTLi2CFTrvv6BIGqdm49UHxQ2+8KO9zo03g9p/CodinQyy
         aOC1fzFkuG5WYdiqp9ppbXEJSWgW1GcsMekntYoQPNPhusZYW8TfYebKl2wEGVwaJi5Y
         zp4Q==
X-Gm-Message-State: APjAAAV1VBLzgODGXsS3EAuBhQC9mdGbAVmFj8RiIt9GU6AVo0VgsIbD
        zAomJf7OrMH5BQEDyXib7Y2ChV6xJ4Q=
X-Google-Smtp-Source: APXvYqycgYJ4Gzgbgcdcjq4J1ha4aIIHC2rr4MArvDn2fxyjV0Vy9hm/THa0WI1QyjDVYz+V64EmYA==
X-Received: by 2002:a17:90a:858a:: with SMTP id m10mr3942252pjn.117.1582301797198;
        Fri, 21 Feb 2020 08:16:37 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:91ff:e31e:f68d:32a9? ([2605:e000:100e:8c61:91ff:e31e:f68d:32a9])
        by smtp.gmail.com with ESMTPSA id b18sm3380479pfb.116.2020.02.21.08.16.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 08:16:36 -0800 (PST)
Subject: Re: [PATCH] io_uring: prevent sq_thread from spinning when it should
 stop
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Hannes Reinecke <hare@suse.com>, io-uring@vger.kernel.org
References: <20200221154216.206367-1-sgarzare@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <916f5b1f-1e01-dfe6-7049-113e7175b66a@kernel.dk>
Date:   Fri, 21 Feb 2020 08:16:33 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200221154216.206367-1-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/21/20 8:42 AM, Stefano Garzarella wrote:
> This patch drops 'cur_mm' before calling cond_resched(), to prevent
> the sq_thread from spinning even when the user process is finished.
> 
> Before this patch, if the user process ended without closing the
> io_uring fd, the sq_thread continues to spin until the
> 'sq_thread_idle' timeout ends.
> 
> In the worst case where the 'sq_thread_idle' parameter is bigger than
> INT_MAX, the sq_thread will spin forever.

Thanks, applied.

-- 
Jens Axboe

