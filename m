Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F30B215B14
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2020 17:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729486AbgGFPoP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jul 2020 11:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729429AbgGFPoP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jul 2020 11:44:15 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F03BC061755
        for <io-uring@vger.kernel.org>; Mon,  6 Jul 2020 08:44:15 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id v6so26157578iob.4
        for <io-uring@vger.kernel.org>; Mon, 06 Jul 2020 08:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=BG/tqCaiZGleWOuLoHciL8DVeFDvo/SpYwonTixO0aM=;
        b=LGmPENYkEg2iycMOeS3Om0rHqEaQ20ma7F7DJjIucDkiUk1B5z7mnqs8RtY02q3IN2
         bMemVssOg5+cdRQkpRQyqJt385nT15c4BPdVHyloAiyr6f/Gv3RJr6kf95wG/hZlZHzb
         8JGP1yvngWCK/4GhrpuWbRTApSCFkrz0awP5KQLyvTHfsdKYA2+r+xaqtLeLfdvxqqLM
         FFHI64l4SvRduFC9FzjpvIOlr9GpjThYr/FVr61wPUpJvCI1dkNxzg1+KCJtouNFLcA8
         48Yd73HKHDEc7j9HrM9OqMOz1KACktD5JpTROh/zN8q5FxpOg1aGcHoOTG0WxIqtQkry
         l6ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BG/tqCaiZGleWOuLoHciL8DVeFDvo/SpYwonTixO0aM=;
        b=AyfWWviBYUCiJPDbylYRm+acgIjZQfcxKTjnxvWPT8l4YLU8B3LFCO0dqrrGOveh/d
         KtvSMfrxQMcJ/tH07V06oAH9POErJWtlbg175EnzeBYCzchMNl+0oghJ6S2LTNj445K8
         szs8JChRNsB8kxZPceLGvAZ66eqj4BYnO3m99ME/3M0Dl+kuV02fjgdT+jIEez6m8E3l
         BSKbbcZAsztmDIHDD17Avhx0aW54uikqVkj9xLDaA6+axjQpdQQeSAosM3kQHC9hIvln
         t9LjkBB5zXi6t1ttF8GE0EH4I3tNl7Q6XZn+rVage9AN5ePOUON6N9lMM6qrMispOwTv
         VI2A==
X-Gm-Message-State: AOAM5317+MneqY/EiGjRcqCNWScWNd1w3oBq1eeOBXWxv9f6WMJNSFHI
        Q0YqOZmVIGfL2tkHD31dCix4mJ51IvvEcQ==
X-Google-Smtp-Source: ABdhPJzVhsEuOdVVPjV6yCsdjEw0fCGV7EXR3P65PGfVAMh6TKg8Cbi6mqSsiy/YnqSlNimrL0DWJw==
X-Received: by 2002:a5d:8f01:: with SMTP id f1mr26134712iof.20.1594050254408;
        Mon, 06 Jul 2020 08:44:14 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id i188sm7987213ioa.33.2020.07.06.08.44.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jul 2020 08:44:13 -0700 (PDT)
Subject: Re: [PATCH v2 0/3] iopoll improvements
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1594047465.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <40a19325-88ad-9c81-42d1-7d9e5ec56f52@kernel.dk>
Date:   Mon, 6 Jul 2020 09:44:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <cover.1594047465.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/6/20 8:59 AM, Pavel Begunkov wrote:
> iopoll'ing should be more responsive with these.
> 
> v2: [3/3] extra need_resched() for reaping (Jens)
> 
> Pavel Begunkov (3):
>   io_uring: don't delay iopoll'ed req completion
>   io_uring: fix stopping iopoll'ing too early
>   io_uring: briefly loose locks while reaping events
> 
>  fs/io_uring.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)

Thanks, nice work. Applied for 5.9.

-- 
Jens Axboe

