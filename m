Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E90B263EDA
	for <lists+io-uring@lfdr.de>; Thu, 10 Sep 2020 09:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgIJHiu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Sep 2020 03:38:50 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54172 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726847AbgIJHir (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Sep 2020 03:38:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599723525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bfeT3r9tepLvXxvXGgvgCH4I0/vfK+CjjcbPnSgoVfU=;
        b=AO+JTbZbtBDMhlwhQPqG/K1Rv8j7mThJrwR24ibev+CK3qP7wNuHCNGy8cT8o4scJtTSa7
        wdIhvBeUsbSCDWcNk59GEe8vj2vxFkIe6v/n/2lU3V/eZe+4ERgHzAcwByfrVAVoMkemus
        YLk6EAZwO/mzi9GwywEY5JrG07EACts=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-Q2HVN6bANK-MNhDNz50NhQ-1; Thu, 10 Sep 2020 03:38:42 -0400
X-MC-Unique: Q2HVN6bANK-MNhDNz50NhQ-1
Received: by mail-wr1-f70.google.com with SMTP id v12so1931698wrm.9
        for <io-uring@vger.kernel.org>; Thu, 10 Sep 2020 00:38:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bfeT3r9tepLvXxvXGgvgCH4I0/vfK+CjjcbPnSgoVfU=;
        b=Fz1q8izmBUNz4GR8emg81iZ3K0gPaMx4Dsf/Gw+of4gAB53T7owcloGPb4FXhF/z+0
         oEEziCWgO4VravlZru+kNRdGgZTyG3ui3/rQZPKTLE8/JzMt3SWBMcZIIgOrpWvK+dcB
         Uh1gg9zggMhOWse1yewS/M7ntQnRuBTaxObAatTyJwFrTEGGHVvlfBzhjSk5zdTiYcQB
         0uqm4j0S4c6xADmlPmFBPpwVlJWm3RBvzqbFUjr6Rlr9PlexyPbrVMohR9d8RFOfKVNA
         cdssrYP8Zfoq3gBb8l3i62s3MwnZKJIWWYK7Cd2GptGheHMjtvGdlR6IYT8/KxAv0n82
         aRrw==
X-Gm-Message-State: AOAM532bnpx1yT6JD5/fO6PLRHqpdirBFTiRIcP2ihnn698VKWV6t11v
        sgYNnpKGfNf/FVbhSfxmSdKmaNhJnwe1JiOQAKKgxek7UBHG/8nms5Gw+vIPDr8llJuQ/5tDYaL
        r6cLf3I//BtVjJVYsSnw=
X-Received: by 2002:a5d:5106:: with SMTP id s6mr8190760wrt.166.1599723520813;
        Thu, 10 Sep 2020 00:38:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy3aEPeimhY/sq0NRzmZ3R7OA8VKS58lUFcXuvQ+RIoHddChl3ADy+eVDrw4GHD/ljMn3aBZg==
X-Received: by 2002:a5d:5106:: with SMTP id s6mr8190749wrt.166.1599723520603;
        Thu, 10 Sep 2020 00:38:40 -0700 (PDT)
Received: from steredhat (host-79-53-225-185.retail.telecomitalia.it. [79.53.225.185])
        by smtp.gmail.com with ESMTPSA id a85sm2407131wmd.26.2020.09.10.00.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 00:38:40 -0700 (PDT)
Date:   Thu, 10 Sep 2020 09:38:37 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Lukas Czerner <lczerner@redhat.com>
Cc:     io-uring@vger.kernel.org
Subject: Re: A way to run liburing tests on emulated nvme in qemu
Message-ID: <20200910073837.u4vypgrcku674n2o@steredhat>
References: <20200909182703.d3wjz3rxys6haij6@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200909182703.d3wjz3rxys6haij6@work>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Lukas,

On Wed, Sep 09, 2020 at 08:27:03PM +0200, Lukas Czerner wrote:
> Hi,
> 
> because I didn't have an acces to a nvme HW I created a simple set of
> scripts to help me run the liburing test suite on emulated nvme device
> in qemu. This has also an advantage of being able to test it on different
> architectures.
> 
> Here is a repository on gihub.
> https://github.com/lczerner/qemu-test-iouring
> 
> I am attaching a README file to give you some sence of what it is.
> 
> It is still work in progress and only supports x86_64 and ppc64 at the
> moment. It is very much Fedora centric as that's what I am using. But
> maybe someone find some use for it. Of course I accept patches/PRs.

Cool! Thanks for sharing!

I had a look and I will definitely try it!

Just a note, maybe you can make configurable through config file also
the number of CPU and amount of memory of the VM.

Thanks,
Stefano

