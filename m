Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D2C33D7CB
	for <lists+io-uring@lfdr.de>; Tue, 16 Mar 2021 16:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbhCPPjm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Mar 2021 11:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231833AbhCPPj2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Mar 2021 11:39:28 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87909C06174A
        for <io-uring@vger.kernel.org>; Tue, 16 Mar 2021 08:39:28 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id o19so3744756qvu.0
        for <io-uring@vger.kernel.org>; Tue, 16 Mar 2021 08:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:in-reply-to:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=0SWcxvHr1doPcXrvFZSpO+eG4ggEv4aMDq+iprwxbi8=;
        b=BV+25bJKleBG/x0giuit6DXn4Ay4UjM87reIk7tNOQBKl+NyqLqHoh4RQuaSpqTrN0
         zN6WmZ+fZSB/TaJNApUow5VgveOp6rDkQc9F1+CAOEUAJD8mfPBN5SdWRBHMYWfRhBwl
         Of2or1Wycz2w6T3RvTiwfSHRPqgFxSHDzK2ul0WoH9A/Id72hX5ZGpRBOWXxc4tu4cmI
         lmW53o1rJXknHULbKyXOD3PbKcUT01WDBoevQZ09alm8LDy+d/fZPpDQjZ8opVsNWTf7
         8TaiUofTK2UhnGttzhNTQ2Oa24jQfZROgcXOp9bWphPIJFxmKnPj4776JAeSBxG0Hx8X
         RSVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:in-reply-to:to:cc:from:subject:message-id
         :date:user-agent:mime-version:content-language
         :content-transfer-encoding;
        bh=0SWcxvHr1doPcXrvFZSpO+eG4ggEv4aMDq+iprwxbi8=;
        b=fpXkKRSMfnHXfifclvLomGRGnPwumUrcf+Q5F2+D79uHCIOPK7d0CjnCfcQh/L9jSv
         EI/vqLA//6YumMyLqhgwNJSaVQkewXoqjQMYQcCXdAlQQGOj/PeygPRa3zYfSwT/Z7m4
         alAgPwqktPDA82aRyTlH8xtlWDbLRQThLOpc6tMHm5EUln9bxMVowyTTRx+P19mv4Lul
         +BlAeWHVlovY6+iQnlCOlkwa68GuOX5xApuu6bF41IxoPvmoXBTam6nmB6UU3YUX/HZV
         F9m1L3WoU3TeInoixfW2lyZCvZtPpdEdaguhZxYDhIKe/ymDTSb1TzzAW2+x9n8jf1mF
         f0Ug==
X-Gm-Message-State: AOAM532myCxvIiPjsmgH/2QNt1r3dZcz2S1I+tgjn7zU/qWOoA5t317M
        M9QMo3gkyoeK5NbQMKgnakoZj6t+wfzQAg==
X-Google-Smtp-Source: ABdhPJyYj4316u+D0jwR2rV1WBcdtoQmujTMokds6jBOLB8nJM1i4qBdfUWkbDd6vLJclQsYHYgp6A==
X-Received: by 2002:a0c:c1cc:: with SMTP id v12mr16100680qvh.47.1615909166803;
        Tue, 16 Mar 2021 08:39:26 -0700 (PDT)
Received: from [192.168.1.200] ([192.159.179.131])
        by smtp.gmail.com with ESMTPSA id 90sm13577831qtc.86.2021.03.16.08.39.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Mar 2021 08:39:26 -0700 (PDT)
Sender: Tavian Barnes <tavianator@gmail.com>
In-Reply-To: 
To:     buytenh@wantstofly.org
Cc:     io-uring@vger.kernel.org
From:   Tavian Barnes <tavianator@tavianator.com>
Subject: RE: [PATCH v4 2/2] io_uring: add support for IORING_OP_GETDENTS
Message-ID: <ea2b3ae7-d5c4-a46e-1d2d-e2c7b5fd8730@tavianator.com>
Date:   Tue, 16 Mar 2021 11:39:25 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

 > IORING_OP_GETDENTS behaves much like getdents64(2) and takes the same
 > arguments, but with a small twist: it takes an additional offset
 > argument, and reading from the specified directory starts at the given
 > offset.
 >
 > For the first IORING_OP_GETDENTS call on a directory, the offset
 > parameter can be set to zero, and for subsequent calls, it can be
 > set to the ->d_off field of the last struct linux_dirent64 returned
 > by the previous IORING_OP_GETDENTS call.
 >
 > Internally, if necessary, IORING_OP_GETDENTS will vfs_llseek() to
 > the right directory position before calling vfs_getdents().

For my envisioned use case it would be important to support reading from
the current file position when offset == -1 (IORING_FEAT_RW_CUR_POS).
Among other things, this would let me fully read a directory with fewer
round-trips.  Normally after the first getdents(), another one must be
issued to distinguish between EOF and a short first read.  It would be
nice to do both calls with linked SQEs so I could immediately know that
I've reached the end of the directory.

 > IORING_OP_GETDENTS may or may not update the specified directory's
 > file offset, and the file offset should not be relied upon having
 > any particular value during or after an IORING_OP_GETDENTS call.

Obviously for the above to work, we'd have to get rid of this 
limitation.  Is that possible?
