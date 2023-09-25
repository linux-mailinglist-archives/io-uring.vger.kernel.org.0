Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4E4E7AD046
	for <lists+io-uring@lfdr.de>; Mon, 25 Sep 2023 08:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbjIYGga (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Sep 2023 02:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232085AbjIYGg3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Sep 2023 02:36:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A97DA3
        for <io-uring@vger.kernel.org>; Sun, 24 Sep 2023 23:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695623737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i1YYbpFs118kf99zhzmzRkzKTOXsWkm5QlprOWgyPU8=;
        b=RlGMbUiu8NYf/mpgvOZLHVVb5MCDmcD4Q6teW6yPt4rQJ+0hYNHNXmBIJY66XnmibYZiaN
        lniImiUB9yE1Mm1wpoyKOr02Hun8bmXy3Ijkgy8qQThp84jF9Xk0t6y/0HO2Ykesux4i/g
        gWUbFxJZrrTmoynchG/jhWMfgOJYs0M=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-346-HqsXpbuHMAikqXMdGLJbxQ-1; Mon, 25 Sep 2023 02:35:35 -0400
X-MC-Unique: HqsXpbuHMAikqXMdGLJbxQ-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-692bc940bb0so3767418b3a.0
        for <io-uring@vger.kernel.org>; Sun, 24 Sep 2023 23:35:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695623734; x=1696228534;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i1YYbpFs118kf99zhzmzRkzKTOXsWkm5QlprOWgyPU8=;
        b=cxW6OpM2aOsQoDyv12+zA5oUXJV0yt5+VynwBATZ9Z3PwdB/sEfsGHXvWInf8UDQxW
         OdiAu3mrS/1w3bfnO1AuXZVgz2BS4dYboJtssQ2LPGKh8gtNResG0orFIXg6F98BQSrE
         JK37vvQewz/65lwbY1NjbVP19Oua5BzdRh53YG/QN0FN0cQOGBMvc3njKZsyAgS0+gCP
         fSrZGenU0PV7uKknjvV42iJV0sG4WcvaIp6U+6HRvmWwJeSqVCY/NrHHT1Xh5QuZ8uFa
         A5d6pFVpg4ch7f6Ku4j5kLtcTKtM5ZYmM7xAcn7CovjxF580hqnU1cYxzXDTYqPwDTXU
         rYqg==
X-Gm-Message-State: AOJu0YyyuZmsOhBDsaNeqaKIePJFyJQE68lqCpV0PdasJga/e9k57JYb
        jUEL6CDjN3/OgjJF02uADzEkr2eUKoQRPJCRUInXwutAIWCOmU4oTA4TeCJw/yP6mkCTzvLuXe8
        s/+pXl41eUVxg6nouktM=
X-Received: by 2002:a05:6300:8083:b0:15e:5952:4fc1 with SMTP id ap3-20020a056300808300b0015e59524fc1mr2604852pzc.29.1695623734699;
        Sun, 24 Sep 2023 23:35:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHnFsLurviJROW+Rwn45qHnB0C1VbzviPVORlZZoy1m5tGPZ2IE2BZ32ATH3LmYNkTVfIK3Yg==
X-Received: by 2002:a05:6300:8083:b0:15e:5952:4fc1 with SMTP id ap3-20020a056300808300b0015e59524fc1mr2604846pzc.29.1695623734295;
        Sun, 24 Sep 2023 23:35:34 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id do17-20020a056a004a1100b00692b0d413c8sm4941640pfb.197.2023.09.24.23.35.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Sep 2023 23:35:33 -0700 (PDT)
Date:   Mon, 25 Sep 2023 14:35:30 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-unionfs@vger.kernel.org, io-uring@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [xfstests generic/617] fsx io_uring dio starts to fail on
 overlayfs since v6.6-rc1
Message-ID: <20230925063530.m4wpinakby26b6q5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20230924142754.ejwsjen5pvyc32l4@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <02c1c68c-61a0-4d93-8619-971c0416b0e6@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02c1c68c-61a0-4d93-8619-971c0416b0e6@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Sep 24, 2023 at 11:52:12AM -0600, Jens Axboe wrote:
> On 9/24/23 8:29 AM, Zorro Lang wrote:
> > Hi,
> > 
> > The generic/617 of fstests is a test case does IO_URING soak direct-IO
> > fsx test, but recently (about from v6.6-rc1 to now) it always fails on
> > overlayfs as [1], no matter the underlying fs is ext4 or xfs. But it
> > never failed on overlay before, likes [2].
> > 
> > So I thought it might be a regression of overlay or io-uring on current v6.6.
> > Please help to review, it's easy to reproduce. My system is Fedora-rawhide/RHEL-9,
> > with upstream mainline linux HEAD=dc912ba91b7e2fa74650a0fc22cccf0e0d50f371.
> > The generic/617.full output as [3].
> 
> It works without overlayfs - would be great if you could include how to
> reproduce this with overlayfs.

Sorry I didn't provide the test steps:

1) git clone git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
2) cd xfstests-dev
3) make -j8  # refer to README, about how to build xfstests
4) vi local.config
# The FSTYP can be other fs, e.g. ext4.
# The TEST_DEV and SCRATCH_DEV can be any local devices you have (even loopdev)
# TEST_DIR and SCRATCH_MNT can be changed too
export FSTYP=xfs
export TEST_DEV=/dev/sda5
export TEST_DIR=/mnt/test
export SCRATCH_DEV=/dev/sda3
export SCRATCH_MNT=/mnt/scratch

5) mkfs.xfs -f /dev/sda5 && mkfs.xfs -f /dev/sda3
6) mkdir -p /mnt/test && mkdir -p /mnt/scratch
7) ./check -overlay generic/617

The step#6 will be failed.

Thanks,
Zorro

> 
> -- 
> Jens Axboe
> 

