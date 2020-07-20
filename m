Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754D6226CC4
	for <lists+io-uring@lfdr.de>; Mon, 20 Jul 2020 19:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728412AbgGTRDO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Jul 2020 13:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728346AbgGTRDO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Jul 2020 13:03:14 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16861C061794;
        Mon, 20 Jul 2020 10:03:14 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id a15so3637538wrh.10;
        Mon, 20 Jul 2020 10:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2z6vfRN45O58360WXxB9JosENc0eD1jtyLCvWHGh1YY=;
        b=NDSdkoTtQtN9k8e5yU0/Q6OJPgewxcja66aFKP8Z7ADQhogTJURkNUpGl91G2fpCCU
         oIkZoqpmJ/x1DP3gXTsvgKPG2qkgxg7rLWiYBSMsPyfyECt8X4/CYlT8TvVEBnGbPnvO
         yhxBYdlA2ZXvEuMIGUxXzn75G7Kua2nEsR2NMUAkmMiJg5uOmfWYmmVFAbfbQbesJWEt
         LlS6Ou/POWTJOLnbo/h7xECwdjuxZ1t2atpEjWmxDllEDUmevYK9J1jM8unZROSC3aJf
         TER0ScfQ2MpTlWMVo4cYQaU10tOokxlhrgFoiZVHfW2W4jXw8xxyOoPY/JVpEy8KWQ/C
         V9Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2z6vfRN45O58360WXxB9JosENc0eD1jtyLCvWHGh1YY=;
        b=rNTqgr0YeqS5MJRRck2jJ1YubKfKVvWigWXM0S4618NGxcbRyAxKc1sh2Foej0fZhu
         +ofG0U/2CfPSX+VWDj3uj15ovuULmAC+By0O20VKi9DN6TBuyGNnFetAAojkKMYHdZXJ
         5pHH16LjotwTm7CPZmIW2NOnuUu8WKzN7s+ho9VGkfeKaszCeeNfP0tz9InarT8w/L/J
         MphzfIxTe1IAqrDFpa5PaEdjD0dvRAkkHyoyuiKXaqE4LwkLisVvfxZr/70kLXHerrUb
         zv/nz2PnjpEhjQeS/9YhEnONw+r16lkXzrLeBfU6TOFPDVcYjnRQ94DNXZ88PBgO/jx6
         jRRQ==
X-Gm-Message-State: AOAM532a58aXQpjytQf7UTc9NmbqDEbbcmi+t6LMo1xibH88B85pNdpA
        pLPaRhplkjA5QV+QcU6j+nGVIyhcOqvYfaT2DQ0=
X-Google-Smtp-Source: ABdhPJzLTTWPjYGX0RzMnJeUOLrnHeGFH1UOcpvlUTIsjffcPcqfeW0pNI6XGZeS+hFgMQxoz0bLNak5dIzAX9LyPrY=
X-Received: by 2002:adf:f0ce:: with SMTP id x14mr22109097wro.137.1595264592763;
 Mon, 20 Jul 2020 10:03:12 -0700 (PDT)
MIME-Version: 1.0
References: <1593974870-18919-5-git-send-email-joshi.k@samsung.com>
 <fe0066b7-5380-43ee-20b2-c9b17ba18e4f@kernel.dk> <20200709085501.GA64935@infradead.org>
 <adc14700-8e95-10b2-d914-afa5029ae80c@kernel.dk> <20200709140053.GA7528@infradead.org>
 <2270907f-670c-5182-f4ec-9756dc645376@kernel.dk> <CA+1E3r+H7WEyfTufNz3xBQQynOVV-uD3myYynkfp7iU+D=Svuw@mail.gmail.com>
 <f5e3e931-ef1b-2eb6-9a03-44dd5589c8d3@kernel.dk> <20200710130912.GA7491@infradead.org>
 <CA+1E3rJSiS58TE=hHv5wVv-umJ19_7zKv-JqZTNzD=xi3MoX1g@mail.gmail.com> <20200710134350.GA14704@infradead.org>
In-Reply-To: <20200710134350.GA14704@infradead.org>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Mon, 20 Jul 2020 22:32:45 +0530
Message-ID: <CA+1E3r+DgR=vVCsUv0cCbPC4MV3Rxfyzee-HWwTogSQ-7F=MoA@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>,
        viro@zeniv.linux.org.uk, bcrl@kvack.org, Damien.LeMoal@wdc.com,
        asml.silence@gmail.com, linux-fsdevel@vger.kernel.org,
        "Matias Bj??rling" <mb@lightnvm.io>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 10, 2020 at 7:13 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Fri, Jul 10, 2020 at 06:59:45PM +0530, Kanchan Joshi wrote:
> > > block doesn't work for the case of writes to files that don't have
> > > to be aligned in any way.  And that I think is the more broadly
> > > applicable use case than zone append on block devices.
> >
> > But when can it happen that we do zone-append on a file (zonefs I
> > asssume), and device returns a location (write-pointer essentially)
> > which is not in multiple of 512b?
>
> All the time.  You open a file with O_APPEND.  You write a record to
> it of any kind of size, then the next write will return the position
> it got written at, which can be anything.
I understand if this is about cached write and we are talking about
O_APPEND in general.
But for direct block I/O write and ZoneFS writes, page-cache is not
used, so write(and zone-append result) will be aligned to underlying
block size.
Even though this patchset uses O_APPEND, it filters regular files and
non zoned-block devices by using new FMODE_ZONE_APPEND flag.

-- 
Joshi
