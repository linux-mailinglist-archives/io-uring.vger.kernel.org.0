Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAA7B18EDA1
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2020 02:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgCWB2a (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 Mar 2020 21:28:30 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34182 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbgCWB2a (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 Mar 2020 21:28:30 -0400
Received: by mail-pf1-f193.google.com with SMTP id 23so6704159pfj.1
        for <io-uring@vger.kernel.org>; Sun, 22 Mar 2020 18:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=AiAyav6BwFSr29hdXCFnFBhxNCa7Q5OcMKiajqm24bE=;
        b=kgtAL3A/6q6jkcurZgQ/kVVXu6f85IzCnxR0nwV9strvNuVnOnmy4sxdJ0k0ru7kJc
         aI4BvhATkLGVtBTW1/B4/RhGO5LO3n1BjpiwKCiTn2PGnbmxFfUtuONEoPBmWdaPvBAo
         +Oxb3JMtGWXYsuNKG2e4JYF7e+htB9ANmvl1zYsE7Z6L5romyFG/jag1HvVFx6j+hyOo
         xH3shSVK3thQEQweHvwtBf83/3468I/gEP1ARm9iQv1+Hb9F6s/5K3dSd7raIRur0I7L
         esl7ic6dt83E9FuT0apPYzZDSViZlff2zT552qXxcSeCESDxns4hTRYwm4+xRJnfhikr
         1Biw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AiAyav6BwFSr29hdXCFnFBhxNCa7Q5OcMKiajqm24bE=;
        b=WApedjXjFsEV40AudsrELVedrN4dDJEuXaIrnlVZeWYdpM0ZNJvIBYLC7HvdnkjN9x
         BLDIYmVByu+ahNMwCVCiDBlDG47z14PgUgsd4GW3uS9S+7XbBDHJJrP6ol4JpJqbQRJQ
         sEowy2o5zv3/ZyUJ1cW1/MaRwRjxJ9b7MpfgoIdL3Miq/zecuumzSpKlVHAjt46D7/ER
         SO4eYSM7C6TTtccTg2uMgsXEROykWiGca0+bYp8D5CuYGwgsAo8zm8hemVPf7hl6n9C5
         RnQIfP2JA/pq85uwsw0qDbIRtG/3mZG48ba5Ca4p9dLfqHxrGIHTFtq/8HLV2p7I3sTn
         EfPA==
X-Gm-Message-State: ANhLgQ0vuRJ0Vm1I6ZGFTI46qAwEAWLgrjrWLrEyxFAOb3LLEaC7Emn1
        fFSCn7ymrRSdAz9+Xg0lzPYJng==
X-Google-Smtp-Source: ADFU+vsBiyW0sX3RAY4WyAPXLoLQgRCGZpgI/fXucknlS62yFbmqVtt4Y5o8sFEPdrgT4rTI7yKCew==
X-Received: by 2002:a62:2a8c:: with SMTP id q134mr10146989pfq.35.1584926908504;
        Sun, 22 Mar 2020 18:28:28 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id m11sm10334604pjq.13.2020.03.22.18.28.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2020 18:28:28 -0700 (PDT)
Subject: Re: [PATCH 1/1] io_uring: Fix ->data corruption on re-enqueue
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <c8d9cc69995858fd8859b339f77901f93574c528.1584912194.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <be427cf7-78d4-7e19-bc16-25aeb0ab33e5@kernel.dk>
Date:   Sun, 22 Mar 2020 19:28:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <c8d9cc69995858fd8859b339f77901f93574c528.1584912194.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/22/20 3:23 PM, Pavel Begunkov wrote:
> work->data and work->list are shared in union. io_wq_assign_next() sets
> ->data if a req having a linked_timeout, but then io-wq may want to use
> work->list, e.g. to do re-enqueue of a request, so corrupting ->data.
> 
> ->data is not necessary, just remove it and extract linked_timeout
> through @link_list.

You're missing a Fixes line again!

-- 
Jens Axboe

