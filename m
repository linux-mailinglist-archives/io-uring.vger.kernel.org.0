Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B198B45A462
	for <lists+io-uring@lfdr.de>; Tue, 23 Nov 2021 15:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbhKWOKV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Nov 2021 09:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbhKWOKU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Nov 2021 09:10:20 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E87C061714
        for <io-uring@vger.kernel.org>; Tue, 23 Nov 2021 06:07:12 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id o17so19961265qtk.1
        for <io-uring@vger.kernel.org>; Tue, 23 Nov 2021 06:07:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1B+wsbZ88hl5UgUalYciMdsusbfEhIih8FbzaStZm40=;
        b=IzeKHci6gF3mobwFwKv1NX/I1NyoxlO2bMeYdaH4G9o6BJr4jOO/pBzkp7IuO4Fk9C
         hkEKAA3PbYrH9zGGxLiY0X4EICGZEhTOzN7sLv7XYN/E0IohlR/A5ZLHgGK3Ri8r4UR8
         potxB9X/8HtUoWr6OhpR9BKARS/+I3jhhA4RogoI24Mg0MtaPiAMi1nlTEGdiioOH8AN
         +cVLMAajLihca7m7Eo8D0Y7B7hDEX4OHsR96G+mZTvqtIc6DnY6p9U9FXAar/t0VgZxj
         J3rdGhcjR7/ebBkoqhGuUW9qd4iVO0MvYk8hWzB+YP4VTpt4kCiqWGZolndHV3hfv0Dz
         sBTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1B+wsbZ88hl5UgUalYciMdsusbfEhIih8FbzaStZm40=;
        b=sV0+tYU866EjaOcW9QDsSMVZSx4Gcv6XqJHGVfCMbZ0lGyXd5XmkdCIwVcMBOcVurf
         DCNfLbrSShCcMbrqROON1AT4p6A9q7DvK2VrwXk6VabMcIZZNo0hgpffOi+xYIlH+lIk
         kaTclvD2PTG6W4OvxsNCEkb3vlFNR+M+kOSmmLVHj7IPn0gUDkQfjxPsUtqxj1mjqf9t
         75PGGzDQfH4u1yUM2ZMlrcKGF0EwiMvw2qtC5t+JCQEE3zHy8kH0sotwu44Y1+YeHlwe
         TYz47MtDdiMrTLxJv4bam7Te3vxXbCiWoGYTcsLmuzBDc4j+K1s2C635Wrv9FsOXx/Qk
         sPeQ==
X-Gm-Message-State: AOAM5308eNPWeCX9QdrwVYxFFUo40GVz/Bwe7PVnWR9771KhzPFDMq+F
        NwMgvcwp5FJlvmC5UWIQ+BlrfA==
X-Google-Smtp-Source: ABdhPJyYjMxOOBpH9i7fCBP2AlMxvvkQbKWd4gm91pcvwoSnMC1ssx3hbE+zkZc6xu0EZxoKnzsH1g==
X-Received: by 2002:a05:622a:18e:: with SMTP id s14mr6882801qtw.203.1637676431388;
        Tue, 23 Nov 2021 06:07:11 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id s2sm6142705qtw.22.2021.11.23.06.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 06:07:10 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mpWRx-000B12-PB; Tue, 23 Nov 2021 10:07:09 -0400
Date:   Tue, 23 Nov 2021 10:07:09 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     David Hildenbrand <david@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Andrew Dona-Couch <andrew@donacou.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Drew DeVault <sir@cmpwn.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        io_uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>, linux-mm@kvack.org
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
Message-ID: <20211123140709.GB5112@ziepe.ca>
References: <20211116114727.601021d0763be1f1efe2a6f9@linux-foundation.org>
 <CFRGQ58D9IFX.PEH1JI9FGHV4@taiga>
 <20211116133750.0f625f73a1e4843daf13b8f7@linux-foundation.org>
 <b84bc345-d4ea-96de-0076-12ff245c5e29@redhat.com>
 <8f219a64-a39f-45f0-a7ad-708a33888a3b@www.fastmail.com>
 <333cb52b-5b02-648e-af7a-090e23261801@redhat.com>
 <ca96bb88-295c-ccad-ed2f-abc585cb4904@kernel.dk>
 <5f998bb7-7b5d-9253-2337-b1d9ea59c796@redhat.com>
 <20211123132523.GA5112@ziepe.ca>
 <10ccf01b-f13a-d626-beba-cbee70770cf1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10ccf01b-f13a-d626-beba-cbee70770cf1@redhat.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Nov 23, 2021 at 02:39:19PM +0100, David Hildenbrand wrote:
> > 
> >> 2) Could be provide a mmu variant to ordinary users that's just good
> >> enough but maybe not as fast as what we have today? And limit
> >> FOLL_LONGTERM to special, privileged users?
> > 
> > rdma has never been privileged
> 
> Feel free to correct me if I'm wrong: it requires special networking
> hardware and the admin/kernel has to prepare the system in a way such
> that it can be used.

Not really, plug in the right PCI card and it works

"special" is a bit of a reach since almost every NIC sold in the > 100GB
segment supports some RDMA.

Jason
