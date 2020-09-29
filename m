Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D198527D060
	for <lists+io-uring@lfdr.de>; Tue, 29 Sep 2020 16:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729930AbgI2OCJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Sep 2020 10:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729073AbgI2OCI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Sep 2020 10:02:08 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E4AC061755
        for <io-uring@vger.kernel.org>; Tue, 29 Sep 2020 07:02:06 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id y13so4902954iow.4
        for <io-uring@vger.kernel.org>; Tue, 29 Sep 2020 07:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8hYFSqZM84qR8+BKEkMEMRnD7Hrs19y/hF0IaftG/i8=;
        b=edVbarORR7oRmXrRTm5ijQfG+kPnlDxLyWbKtoz27OlhoJBGXOcURPAJ7J5l/yqIKl
         7U99ZW2E2ZGn7UBzxROuqpiNa9Bu8VNfKhRtKcxhwKOVw48sNIHDWqwNhvm6rEvtPKNE
         mlkUNH7JrBV2gSLy0EEL8HWLY7hJ3RKqsOYiM4IJGTUii36WQ8mLDRAJ9CXYxCDBYCNZ
         ImwTY3ReOL0jYtZrE1ibCQk/uPPU6jKPAZ2UeGvu/cyIsXImca7kfN8/YB/5QK6iGxuH
         8ECq8wzRz/mVdsGpZg/bmUsfQBTRiIlLwbQzVwdetLlKWgjOuTX/fDI8O8YX5zsJxukZ
         lc5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8hYFSqZM84qR8+BKEkMEMRnD7Hrs19y/hF0IaftG/i8=;
        b=HrUCr+p7MAeKfOGeN7p/dNv3qX6dbRS+eembKj328VUnj0fgGUN9SYvZa6X6lR+eCI
         IMWBkP2rOueykKaQwCnpHcMhOQ+PPGNRAKAK+0zkCC1dV2tCLs43redbKLiBtf8qrG19
         4f0gTMep1YgEgqgxrYzkOUukw93gk15RYF6MLU87V9uNgaF1kflql1pBofJsQYJxjxpN
         xCjs3fSlPDkTYWoCwULf3vG5IavBgUEPE9m0ERWIYbFZeiCYHRdNO9FadZygFvUUMROX
         Dd6PqV2hP5ofktHT/lNBersjlVYGtJuPSydMmLzisUxFFrzmewuG3JG1uKfInpmtzWe3
         kEaQ==
X-Gm-Message-State: AOAM533ZiNvNwS+aFvbz+TiOsQmr/l3Zmuz3ZRgqRPtLnNcA+hcv+nx6
        SRjxpdG52GwIvu/vrKNsIrjpMfySOvXTUA==
X-Google-Smtp-Source: ABdhPJx87GnHM0UIyJLqwjNutW//DeuvKuEKcJqev8qHhkq3KwWHkx0s2Ezf7Y3ehbFMZbi83ufByg==
X-Received: by 2002:a5d:8897:: with SMTP id d23mr2511240ioo.137.1601388125584;
        Tue, 29 Sep 2020 07:02:05 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l10sm2388896ilm.75.2020.09.29.07.02.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2020 07:02:04 -0700 (PDT)
Subject: Re: [PATCH liburing v2 0/3] Add restrictions stuff in the man pages
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     io-uring@vger.kernel.org
References: <20200929132339.45710-1-sgarzare@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0d7abc30-1de0-e487-ddcd-602cdc48b557@kernel.dk>
Date:   Tue, 29 Sep 2020 08:02:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200929132339.45710-1-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/29/20 7:23 AM, Stefano Garzarella wrote:
> Hi Jens,
> this series adds description of restrictions, how to enable io_uring
> ring, and related errors in the man pages.
> The patches are also available here:
> 
> https://github.com/stefano-garzarella/liburing (branch: restrictions-man-pages)
> 
> v2:
>   - rebased on master after the split of ERRORS section in man/io_uring_enter.2
>   - Patch 2: fixed grammar issues [Jens]
>   - Patch 3: put the errors in right section
> 
> v1: https://lore.kernel.org/io-uring/20200911133408.62506-1-sgarzare@redhat.com

Applied, thanks!

-- 
Jens Axboe

