Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8455A1FED92
	for <lists+io-uring@lfdr.de>; Thu, 18 Jun 2020 10:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbgFRI1u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Jun 2020 04:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728493AbgFRI1o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Jun 2020 04:27:44 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58AA7C0613EF
        for <io-uring@vger.kernel.org>; Thu, 18 Jun 2020 01:27:44 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id d128so4706547wmc.1
        for <io-uring@vger.kernel.org>; Thu, 18 Jun 2020 01:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=javigon-com.20150623.gappssmtp.com; s=20150623;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=zE4oI/xjk4gPn+qKQVZsXwzGGdGfMEP73737Hdz+jyM=;
        b=Cj/5mRQVF5EPtKV73CeRrVMQAnPUOaupFkki1CVBBIZx0MCP5TxMZOABRWfLgMiKx5
         OrvSylExR0QnjfxyulmGMFOmZ50JLI7Y2dhI7mEAANxOhD7OYltwyqPY8MyoLq6Jtoi/
         XPyfWDiJPghNpSFfnB51GYw3ZxKlDGIn+dl2geBSCCc9twmRhl8k3NBf98cnG+Cr7/ZN
         H00YxlfJyrRH0AD89VWqfIUpmpoZI//X+cpY448HsuY0jNb4cKG3cse5gkt9h5kq7ZOK
         kFhfUa3vrzFsZ2JAbG2FYifin3cYU8Xvd4Y/BITy+rGZ+qgN3RwEz0LTovGyW1s9VniT
         0NVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=zE4oI/xjk4gPn+qKQVZsXwzGGdGfMEP73737Hdz+jyM=;
        b=qlC2lqduZljrCsbXkpea2UN/nJUs/mtkbcT6zyVvqSap91N1RidibVOB3B4YBFV2hk
         K8r2b01Swpn7rgZBdI78Dsx8CkAIlb5tWfZDn/bj71tfL6TGajp1PzRkZN/Aj1lAcPE/
         KBoDTb+sDrm9tpzNXc48h9ECyeD+86HYytGukfU7oRLytpYqYlHAbqOGdd5b2vmfTlUE
         9k6JQjD8p6SG1kjCe5hrBHDwyFku/YmCS/mNCLRhAlg3v7CMtSea5d9NMoJ/abBIl9JC
         4gE04r1C3f14CFOM/7zKghDZNc3MwUicW5Ft48us9qU1TVpacKBkU3+4dse0yALkWdBU
         AxlQ==
X-Gm-Message-State: AOAM532bJ7EdQmLzozk3BNC4HMpvCOMPqfVgp3LRkmxB6Fw7hbgQXEh2
        03PaECORNPSN3emMRtpItJB4iQ==
X-Google-Smtp-Source: ABdhPJzkiRDfED3V6pOmykpfjJbJipeCADa+NhvfgJkz15HsHexnwxQbYOhGefGNDFZWUU3aNLZWVw==
X-Received: by 2002:a1c:2602:: with SMTP id m2mr1176878wmm.50.1592468862890;
        Thu, 18 Jun 2020 01:27:42 -0700 (PDT)
Received: from localhost ([194.62.217.57])
        by smtp.gmail.com with ESMTPSA id c6sm2627442wma.15.2020.06.18.01.27.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 01:27:42 -0700 (PDT)
From:   "Javier =?utf-8?B?R29uesOhbGV6?=" <javier@javigon.com>
X-Google-Original-From: Javier =?utf-8?B?R29uesOhbGV6?= <javier.gonz@samsung.com>
Date:   Thu, 18 Jun 2020 10:27:40 +0200
To:     Matias =?utf-8?B?QmrDuHJsaW5n?= <mb@lightnvm.io>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, bcrl@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, selvakuma.s1@samsung.com,
        nj.shetty@samsung.com, Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <keith.busch@wdc.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/3] zone-append support in aio and io-uring
Message-ID: <20200618082740.i4sfoi54aed6sxnk@mpHalley.local>
References: <CGME20200617172653epcas5p488de50090415eb802e62acc0e23d8812@epcas5p4.samsung.com>
 <1592414619-5646-1-git-send-email-joshi.k@samsung.com>
 <f503c488-fa00-4fe2-1ceb-7093ea429e45@lightnvm.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f503c488-fa00-4fe2-1ceb-7093ea429e45@lightnvm.io>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 18.06.2020 10:04, Matias Bjørling wrote:
>On 17/06/2020 19.23, Kanchan Joshi wrote:
>>This patchset enables issuing zone-append using aio and io-uring direct-io interface.
>>
>>For aio, this introduces opcode IOCB_CMD_ZONE_APPEND. Application uses start LBA
>>of the zone to issue append. On completion 'res2' field is used to return
>>zone-relative offset.
>>
>>For io-uring, this introduces three opcodes: IORING_OP_ZONE_APPEND/APPENDV/APPENDV_FIXED.
>>Since io_uring does not have aio-like res2, cqe->flags are repurposed to return zone-relative offset
>
>Please provide a pointers to applications that are updated and ready 
>to take advantage of zone append.

Good point. We are posting a RFC with fio support for append. We wanted
to start the conversation here before.

We can post a fork for improve the reviews in V2.

>
>I do not believe it's beneficial at this point to change the libaio 
>API, applications that would want to use this API, should anyway 
>switch to use io_uring.

I can see why you say this, but isn't it too restrictive to directly
drop libaio support? We can split the patches and merge uring first- no
proble,.

>
>Please also note that applications and libraries that want to take 
>advantage of zone append, can already use the zonefs file-system, as 
>it will use the zone append command when applicable.

Sure. There are different paths available already, which is great. We
have use cases for uring and would like to enable them too.

Thanks,
Javier
