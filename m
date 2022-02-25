Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFE54C3AEB
	for <lists+io-uring@lfdr.de>; Fri, 25 Feb 2022 02:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236350AbiBYB2C (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Feb 2022 20:28:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234976AbiBYB2C (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Feb 2022 20:28:02 -0500
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A30167FB3;
        Thu, 24 Feb 2022 17:27:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1645752449; x=1677288449;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lNpw/dA4OwOk2L5V0WemMzN2TJdkBbxBRc5/B0XNe+E=;
  b=LXpjeBYf4R9jbTVjRoF9SdYEuLkJxa4HmOjEzF2blP6V/PMEDMoZGXBL
   TFyiQq2FrdoMF6yoooz7KLi6Ygc50wqsB3pBZa1vWZjdtralB9s9v7Lsv
   F4yaKzIVWKdrAP1WDbY4rM0+hHAMKBjZZYHcODQl+jg8bkaq/rlfujJ3A
   o=;
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 24 Feb 2022 17:27:27 -0800
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 17:27:27 -0800
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Thu, 24 Feb 2022 17:27:27 -0800
Received: from qian (10.80.80.8) by nalasex01a.na.qualcomm.com (10.47.209.196)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15; Thu, 24 Feb
 2022 17:27:26 -0800
Date:   Thu, 24 Feb 2022 20:27:24 -0500
From:   Qian Cai <quic_qiancai@quicinc.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     Marek Szyprowski <m.szyprowski@samsung.com>, <kernel-team@fb.com>,
        "Stefan Roesch" <shr@fb.com>, <io-uring@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v3 0/2] io-uring: Make statx api stable
Message-ID: <YhgwfHtP7ry83oUr@qian>
References: <20220215180328.2320199-1-shr@fb.com>
 <164555550976.110748.6933069169641927964.b4-ty@kernel.dk>
 <CGME20220224124715eucas1p2a7d1b7f2a5131ef1dd5b8280c1d3749b@eucas1p2.samsung.com>
 <5e0084b9-0090-c2a6-ab64-58fd1887d95f@samsung.com>
 <a906fc93-1295-f27c-b96a-32571039bf92@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a906fc93-1295-f27c-b96a-32571039bf92@kernel.dk>
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Feb 24, 2022 at 07:09:35AM -0700, Jens Axboe wrote:
> > Freeing unused kernel image (initmem) memory: 1024K
> > Run /sbin/init as init process
> > systemd[1]: System time before build time, advancing clock.
> > systemd[1]: Cannot be run in a chroot() environment.
> > systemd[1]: Freezing execution.
> > 
> > Reverting them on top of next-20220223 fixes the boot issue. Btw, those 
> > patches are not bisectable. The code at 
> > 30512d54fae354a2359a740b75a1451b68aa3807 doesn't compile.
> 
> Thanks, I'll drop them from for-next until we figure out what that is.

FYI, this breaks the boot on bare-metal as well.

Loading, please wait...
Starting version 245.4-4ubuntu3.15
Running in chroot, ignoring request.
Running in chroot, ignoring request.
Running in chroot, ignoring request.
Running in chroot, ignoring request.
Running in chroot, ignoring request.
/scripts/init-top/console_setup: line 90: can't create /dev/tty1: No such device or address
/scripts/init-top/console_setup: line 126: can't open /dev/tty1: No such device or address
Begin: Loading essential drivers ... /init: line 155: modprobe: Permission denied
/init: line 155: modprobe: Permission denied
/init: line 155: modprobe: Permission denied
/init: line 155: modprobe: Permission denied
/init: line 155: modprobe: Permission denied
/init: line 155: modprobe: Permission denied
/init: line 155: modprobe: Permission denied
/init: line 155: modprobe: Permission denied
