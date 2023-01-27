Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E09467EC9E
	for <lists+io-uring@lfdr.de>; Fri, 27 Jan 2023 18:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234568AbjA0RkI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Jan 2023 12:40:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234618AbjA0RkH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Jan 2023 12:40:07 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD5711664
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 09:40:05 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id l7so703043ilf.0
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 09:40:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nMdaWi0s/rkZk6dpLDDLpOfnmZySxuJZ3EtfBdn16L4=;
        b=PXbTywLRP6ubXT7FPoKdDGpXe4vQtSov47Xim00Roq1wBQM7DadvHVBK9/T48f6tF0
         X91oBOIps/pJF9HQQZbebvr97pMQZQv/Qykh+9ST29igMQIHd1BbcnBPXXCdgHXZEUJI
         ybeGfOESjyuDT6dFUIE6FDfneqxm6ZejSBhGxMc1dVKYUOYsJcDD0sUNH/UPOHzEfTZZ
         mSRy6caSCROIHTpnNyFLu647CHdzJXNp75c8Zb37wbT50hrJyyf9BZB9fFX3WwEeKbwr
         J/IxB0qvubA5kiZkPTSkEfLmDi7NTXV5Hy7sAj5m95oLlsiZEnw3UYbrxWT3FnbUnvHh
         t7GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nMdaWi0s/rkZk6dpLDDLpOfnmZySxuJZ3EtfBdn16L4=;
        b=7IFuAxOgltxIxKhQYMwCnF3jEP1LVMvCaXmz/RQcv7LYuyLp5S4nMkB3T7Rp6VOh65
         uG+1I6TkPf/RkVYYVgK7PzOB3fpB4LWpet7H8/7SrIB0W6b9REyEbcv76prpB4V4pJz+
         chklxXdXns0KuDtrxezxzDYA4ixQ8cmQij5tc/kBx1Y/Y4fPz2+CLhkUy5b15/4DAuAL
         VzxF9g2p8gZNzS/ThKO+9Du1u7jVs55SNf3mpe7C9eF5SdrPX+Me2A5xri1x1uSgVFEN
         GFCq60PFUfzd1KtYmc9GPgrZ913305d2/voUB25Uk5ISYokMCDzmZ77WjbXJQEwid9n0
         IjiA==
X-Gm-Message-State: AFqh2koUns+ivZ7qcb0U2z2FJvFo/ufUBvcDXkxNG81fc6imTeYUd2Of
        mPo6SUwNPIyCkoou77gvhKHjoA==
X-Google-Smtp-Source: AMrXdXv9DihVENlcQq0pOotAPOzVVKESgzXFyP8XLUMwU5cLPg43k/1mKykmI89PI8spm0omdIPZ5A==
X-Received: by 2002:a92:d3c2:0:b0:30f:4feb:50c7 with SMTP id c2-20020a92d3c2000000b0030f4feb50c7mr3682315ilh.3.1674841204444;
        Fri, 27 Jan 2023 09:40:04 -0800 (PST)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id h13-20020a0566380f0d00b0039e2e4c82c8sm1138314jas.123.2023.01.27.09.40.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jan 2023 09:40:03 -0800 (PST)
Message-ID: <da695bf4-bd9b-a03d-3fbc-686724a7b602@kernel.dk>
Date:   Fri, 27 Jan 2023 10:40:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v1 0/2] two suggested iouring op audit updates
Content-Language: en-US
To:     Richard Guy Briggs <rgb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>, Stefan Roesch <shr@fb.com>,
        Christian Brauner <brauner@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <cover.1674682056.git.rgb@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1674682056.git.rgb@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/27/23 10:23 AM, Richard Guy Briggs wrote:
> A couple of updates to the iouring ops audit bypass selections suggested in
> consultation with Steve Grubb.
> 
> Richard Guy Briggs (2):
>   io_uring,audit: audit IORING_OP_FADVISE but not IORING_OP_MADVISE
>   io_uring,audit: do not log IORING_OP_*GETXATTR
> 
>  io_uring/opdef.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Look fine to me - we should probably add stable to both of them, just
to keep things consistent across releases. I can queue them up for 6.3.

-- 
Jens Axboe


