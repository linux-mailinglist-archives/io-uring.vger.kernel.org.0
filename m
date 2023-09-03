Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61DE8790EF3
	for <lists+io-uring@lfdr.de>; Mon,  4 Sep 2023 00:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348981AbjICWbG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Sep 2023 18:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245756AbjICWbE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Sep 2023 18:31:04 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF32FE
        for <io-uring@vger.kernel.org>; Sun,  3 Sep 2023 15:30:55 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-1c50438636fso786006fac.1
        for <io-uring@vger.kernel.org>; Sun, 03 Sep 2023 15:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1693780255; x=1694385055; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Nv6YpToDNZJcA/Ccz8YHJKQ8zE37n7OYKvDh05ivZ8M=;
        b=eLvFMZ6HweV3i75Mje3KyiQMHp72f3fVYJp4X8QBR1sUoWt5LbUe2oYe6gz7J03xSV
         aHsv7iDil4KTnD32vRddboJhyW5dIQThpWZBfmdQlNdU/+SQKnZqTkI+8YNmhDFqSNM4
         M/5uOEBZigGEpPC3vmfjiwnDFOd47IixsMl044OpUX7QG234XdFYwtba/jPyi6PCo/kZ
         okP+nX6zzbLjyilv/Ocy1qCe5aC4gkdgDOfyh92JWGe8bVg+DmwjlPuuV3kM/V8mAkRG
         YMrGVWwsvVs5uRT8A9BN8JD3DAOcyXyqtn49LxBGuGru+09OFjvSzk6tINPlQnplnbJD
         r/Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693780255; x=1694385055;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nv6YpToDNZJcA/Ccz8YHJKQ8zE37n7OYKvDh05ivZ8M=;
        b=LHlNUTr3nF/QZXR8KLNHWpP7W7g4ezdRSzDX5Y8OFkaBea3Hv+gt1biG0uFlHAUUcz
         Km9qYRbzjQjaHYoVr5fa2vIDjd5yvmFpEDSQQLsPWjuvEIUZe1QdtyiIqWSTENZYcjOV
         KVGt0NWpFSVzyu0hMSnJ+MaAhxW4pv+AHgyKT3NgL4YaXZ1s16lL1n4phmo4CWRVGR8A
         vd916uJka+4wlsBAZ6Ep+RdVRd2DWnZR9gmRwgH7STB+LJYYV+QucSe1XbQ2GGO38iMN
         DD1AtKAz+nj0xuludW/zwCnSCswbFlBNFlzZ4lahr/4LPhd3LQ498lBo1a0Ye6T679q4
         AiRQ==
X-Gm-Message-State: AOJu0YztLKY2u/Fi0FOY656IJwYeCjlBxFT+kemIqmenLuUa+7Ftf70m
        rifm1NCB1D0Cn+1hZWZq/HHO8A==
X-Google-Smtp-Source: AGHT+IGLu9Ypqvz2HQH6Ke2apJHDtGTD5ZHmV6+9u1MT+8XuCmbNG2jkA6AQg79Zc5mY+kWQOWShIA==
X-Received: by 2002:a05:6870:568d:b0:1be:c8e2:3ec3 with SMTP id p13-20020a056870568d00b001bec8e23ec3mr11536784oao.14.1693780255066;
        Sun, 03 Sep 2023 15:30:55 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id i15-20020a63bf4f000000b00565e96d9874sm5648132pgo.89.2023.09.03.15.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Sep 2023 15:30:54 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qcvcK-00ASFy-0F;
        Mon, 04 Sep 2023 08:30:52 +1000
Date:   Mon, 4 Sep 2023 08:30:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Hao Xu <hao.xu@linux.dev>
Cc:     Matthew Wilcox <willy@infradead.org>, io-uring@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-cachefs@redhat.com,
        ecryptfs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-unionfs@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-btrfs@vger.kernel.org, codalist@coda.cs.cmu.edu,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-mm@kvack.org, linux-nilfs@vger.kernel.org,
        devel@lists.orangefs.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-mtd@lists.infradead.org,
        Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH 07/11] vfs: add nowait parameter for file_accessed()
Message-ID: <ZPUJHAKzxvXiEDYA@dread.disaster.area>
References: <20230827132835.1373581-1-hao.xu@linux.dev>
 <20230827132835.1373581-8-hao.xu@linux.dev>
 <ZOvA5DJDZN0FRymp@casper.infradead.org>
 <c728bf3f-d9db-4865-8473-058b26c11c06@linux.dev>
 <ZO3cI+DkotHQo3md@casper.infradead.org>
 <642de4e6-801d-fcad-a7ce-bfc6dec3b6e5@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <642de4e6-801d-fcad-a7ce-bfc6dec3b6e5@linux.dev>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 30, 2023 at 02:11:31PM +0800, Hao Xu wrote:
> On 8/29/23 19:53, Matthew Wilcox wrote:
> > On Tue, Aug 29, 2023 at 03:46:13PM +0800, Hao Xu wrote:
> > > On 8/28/23 05:32, Matthew Wilcox wrote:
> > > > On Sun, Aug 27, 2023 at 09:28:31PM +0800, Hao Xu wrote:
> > > > > From: Hao Xu <howeyxu@tencent.com>
> > > > > 
> > > > > Add a boolean parameter for file_accessed() to support nowait semantics.
> > > > > Currently it is true only with io_uring as its initial caller.
> > > > 
> > > > So why do we need to do this as part of this series?  Apparently it
> > > > hasn't caused any problems for filemap_read().
> > > > 
> > > 
> > > We need this parameter to indicate if nowait semantics should be enforced in
> > > touch_atime(), There are locks and maybe IOs in it.
> > 
> > That's not my point.  We currently call file_accessed() and
> > touch_atime() for nowait reads and nowait writes.  You haven't done
> > anything to fix those.
> > 
> > I suspect you can trim this patchset down significantly by avoiding
> > fixing the file_accessed() problem.  And then come back with a later
> > patchset that fixes it for all nowait i/o.  Or do a separate prep series
> 
> I'm ok to do that.
> 
> > first that fixes it for the existing nowait users, and then a second
> > series to do all the directory stuff.
> > 
> > I'd do the first thing.  Just ignore the problem.  Directory atime
> > updates cause I/O so rarely that you can afford to ignore it.  Almost
> > everyone uses relatime or nodiratime.
> 
> Hi Matthew,
> The previous discussion shows this does cause issues in real
> producations: https://lore.kernel.org/io-uring/2785f009-2ebb-028d-8250-d5f3a30510f0@gmail.com/#:~:text=fwiw%2C%20we%27ve%20just%20recently%20had%20similar%20problems%20with%20io_uring%20read/write
> 

Then separate it out into it's own patch set so we can have a
discussion on the merits of requiring using noatime, relatime or
lazytime for really latency sensitive IO applications. Changing code
is not always the right solution...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
