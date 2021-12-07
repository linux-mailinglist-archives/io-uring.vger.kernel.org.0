Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 383D646C095
	for <lists+io-uring@lfdr.de>; Tue,  7 Dec 2021 17:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234804AbhLGQVl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Dec 2021 11:21:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239575AbhLGQVg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Dec 2021 11:21:36 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3FFC061574
        for <io-uring@vger.kernel.org>; Tue,  7 Dec 2021 08:18:05 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id w4so14328178ilv.12
        for <io-uring@vger.kernel.org>; Tue, 07 Dec 2021 08:18:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=5z1/LJzeWhXjiuq3wSSyXXld1uR/I7p3ZHYF6GBXjoI=;
        b=fYLwewQbwtxWL5Su2LWqpA1IplOsmSC8UHeqwyg78RQlaRLEudl7bL6Fd2t0x6mQim
         xeZCuzOupxcb7/U50+rVS+0FeBAQcjFMNYi98Wqu/BhbjKRmQpY6lHkLv6eul1e5tMIB
         4LKNuLieL/ZDRvlPUuKDPEGzl/QUx/iNLWhrKx72XhhvUDG92Wl5d+ouQDUS7DZzJWM+
         dv34uCStRfFZfbN0fh25aWcqMtsxAlfx6gH2p7lIYb6QyD4EOkVTaNfdPWyOCRsKk9Pb
         uaIoHaskHQXC1A3aWls+ugAUUHNl+tcmgI4pR53EcKGvyyzFYSW8x5L+YFTljTlfCgyN
         UrIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=5z1/LJzeWhXjiuq3wSSyXXld1uR/I7p3ZHYF6GBXjoI=;
        b=ngnVbrMuHkb607R7bq3CHNV2ldbNn4mYpvLSucKkxiGEWrJnlBjsuhwf4sxfW0FrMl
         AOLbSLa8TAYhMGQKNEakCX/uzr/yPYQ5Jv33EQxr8xdJzMhRnXUA6soQipkstzAy9fc2
         6r6nHLnDIQjxs1CX9hrJR18uHhjgl7mkzD1Zizl9lmJG3Rb9ujFTenqKbEJIVo2RupMA
         s/CF4MkmcAD5dHzsENuT2RAuABrJOPLk85QGI3sdJRooe7CL6MbgPpS6jlIbgJ7AF6DY
         JUU7v5iCX554xABGAurGD3rH9qJmi+5SzYTOlTqQtTs4Usj6wK+qeXGIittUwYT3x63A
         ndHA==
X-Gm-Message-State: AOAM532ijyhlHb+IHcUHDLZ0IB3xfMo5DcaNMQrmcP1IDL6F8Z+cn1ZG
        e7e+AYAu9LeUvSMD6fmwgC698sWurgPeYfQo
X-Google-Smtp-Source: ABdhPJxrVGM1yqjH0vNvajNqewUmKLv/OSleeTePCfPq2rPHCeJRnjxvoWVRxNx8/Jv9fMT+bPwDlA==
X-Received: by 2002:a05:6e02:1c02:: with SMTP id l2mr309376ilh.37.1638893885089;
        Tue, 07 Dec 2021 08:18:05 -0800 (PST)
Received: from x1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id x2sm46374iom.46.2021.12.07.08.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 08:18:04 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
In-Reply-To: <8c81bf9b01a54d1214bb65678c2ff1362a9f9328.1638364791.git.asml.silence@gmail.com>
References: <8c81bf9b01a54d1214bb65678c2ff1362a9f9328.1638364791.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 1/1] man/io_uring_enter.2: notes about cqe-skip & drain interoperability
Message-Id: <163889388472.160679.7321825795401385593.b4-ty@kernel.dk>
Date:   Tue, 07 Dec 2021 09:18:04 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 1 Dec 2021 13:20:37 +0000, Pavel Begunkov wrote:
> IOSQE_CQE_SKIP_SUCCESS can't be used together with draining in a single
> ring, add a paragraph explaining what are the restrictions.
> 
> 

Applied, thanks!

[1/1] man/io_uring_enter.2: notes about cqe-skip & drain interoperability
      commit: 1d86befc0552332fce761a63b2e28e33b743a074

Best regards,
-- 
Jens Axboe


