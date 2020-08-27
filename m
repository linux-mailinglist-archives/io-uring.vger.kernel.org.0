Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A618F25467E
	for <lists+io-uring@lfdr.de>; Thu, 27 Aug 2020 16:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgH0OKa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Aug 2020 10:10:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44184 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728050AbgH0OKN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Aug 2020 10:10:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598537411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p3UaJor8m6UPSLfz0Cwgwz9tei6T+Ko+yHdee7F5pCI=;
        b=U3hgkicwANJkdU0V4e1fkj6xC1xjHJzZDJI0K86zdcAgU52LwoDNH7yDlqXKJIAbxAkv9v
        9OQiRlUN9WbLIiQabAluz0YjHk0xssVBM5H/HQcDF40mJJ0fKi/wI+LPBmuybrU6NaGZ1h
        RXyMzQnKYUa380uCGPIosDcicNq8I3A=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40--xsL0NCvO_WeNpxeJ16FJg-1; Thu, 27 Aug 2020 10:10:08 -0400
X-MC-Unique: -xsL0NCvO_WeNpxeJ16FJg-1
Received: by mail-wm1-f70.google.com with SMTP id w3so2026782wmg.4
        for <io-uring@vger.kernel.org>; Thu, 27 Aug 2020 07:10:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=p3UaJor8m6UPSLfz0Cwgwz9tei6T+Ko+yHdee7F5pCI=;
        b=tqHj100uNVrWdMntKW7zXSbBSAeosdFQZxUewToxhvyuuUQyushYG++h3acS/M75ZC
         PW1t3/U5m71gbdUB/K5Ex4/nnNCd/NHoI8uWeEyX62j2JenHsahhCWpBPoVhVvAJav4k
         w3aGlmgAa46FgObWVyBBNlVl+Gu1/DUshids8EO8o+L60rNra9RSU2+MK2sDqLJNVTye
         0TcZokGlAF35WXQUkuATzYVjc1MVgGB+Y33bIgngseXSoCXgtacne3MS+gRu6C1FPvVJ
         DjE66zQKQLubV+umSR1JKWkZTie+NYtcAhlU/ucq/DKg7DcVWQfC/VrrtdH+MDMBVWTc
         t7Sw==
X-Gm-Message-State: AOAM531NPHMcDf+F6TwBTS/RTfDuga+s6IGgylRyGTAppq8uOdBzHSqs
        iozChh50hHzK4ct+0u5gHAmmbTMiBpDg/MkqQCxBkbw0ZlFVUpwAgB5nSLHGq7tb8NPV/esFfh5
        z6CFWBgoKRGVbmz6cn0Y=
X-Received: by 2002:adf:ea0b:: with SMTP id q11mr18400749wrm.285.1598537407343;
        Thu, 27 Aug 2020 07:10:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwIyoHL6pydlVZ4mUCwXiexrkWU5beyLiimAC7oyStXfYcu8GXZZ2ytD3aLAfsrScWOA6WOpQ==
X-Received: by 2002:adf:ea0b:: with SMTP id q11mr18400722wrm.285.1598537407089;
        Thu, 27 Aug 2020 07:10:07 -0700 (PDT)
Received: from steredhat.lan ([5.171.209.212])
        by smtp.gmail.com with ESMTPSA id p8sm6052216wrq.9.2020.08.27.07.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 07:10:06 -0700 (PDT)
Date:   Thu, 27 Aug 2020 16:10:02 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Aleksa Sarai <asarai@suse.de>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Jann Horn <jannh@google.com>, io-uring@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
        Kees Cook <keescook@chromium.org>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v5 0/3] io_uring: add restrictions to support untrusted
 applications and guests
Message-ID: <20200827141002.an34n2nx6m4dfhce@steredhat.lan>
References: <20200827134044.82821-1-sgarzare@redhat.com>
 <2ded8df7-6dcb-ee8a-c1fd-e0c420b7b95d@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ded8df7-6dcb-ee8a-c1fd-e0c420b7b95d@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Aug 27, 2020 at 07:50:44AM -0600, Jens Axboe wrote:
> On 8/27/20 7:40 AM, Stefano Garzarella wrote:
> > v5:
> >  - explicitly assigned enum values [Kees]
> >  - replaced kmalloc/copy_from_user with memdup_user [kernel test robot]
> >  - added Kees' R-b tags
> > 
> > v4: https://lore.kernel.org/io-uring/20200813153254.93731-1-sgarzare@redhat.com/
> > v3: https://lore.kernel.org/io-uring/20200728160101.48554-1-sgarzare@redhat.com/
> > RFC v2: https://lore.kernel.org/io-uring/20200716124833.93667-1-sgarzare@redhat.com
> > RFC v1: https://lore.kernel.org/io-uring/20200710141945.129329-1-sgarzare@redhat.com
> > 
> > Following the proposal that I send about restrictions [1], I wrote this series
> > to add restrictions in io_uring.
> > 
> > I also wrote helpers in liburing and a test case (test/register-restrictions.c)
> > available in this repository:
> > https://github.com/stefano-garzarella/liburing (branch: io_uring_restrictions)
> > 
> > Just to recap the proposal, the idea is to add some restrictions to the
> > operations (sqe opcode and flags, register opcode) to safely allow untrusted
> > applications or guests to use io_uring queues.
> > 
> > The first patch changes io_uring_register(2) opcodes into an enumeration to
> > keep track of the last opcode available.
> > 
> > The second patch adds IOURING_REGISTER_RESTRICTIONS opcode and the code to
> > handle restrictions.
> > 
> > The third patch adds IORING_SETUP_R_DISABLED flag to start the rings disabled,
> > allowing the user to register restrictions, buffers, files, before to start
> > processing SQEs.
> > 
> > Comments and suggestions are very welcome.
> 
> Looks good to me, just a few very minor comments in patch 2. If you
> could fix those up, let's get this queued for 5.10.
> 

Sure, I'll fix the issues. This is great :-)

Thanks,
Stefano

