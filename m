Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6262ABF00
	for <lists+io-uring@lfdr.de>; Mon,  9 Nov 2020 15:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731745AbgKIOm7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Nov 2020 09:42:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731612AbgKIOm5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Nov 2020 09:42:57 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363E3C0613CF
        for <io-uring@vger.kernel.org>; Mon,  9 Nov 2020 06:42:57 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id z2so8468666ilh.11
        for <io-uring@vger.kernel.org>; Mon, 09 Nov 2020 06:42:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3ehw22GU6NrQDTL+oBdXxN0niE79/e+SUzQT5o4Dv28=;
        b=cKl8Nr/tQCjQOdgkH+HMJNGtQcsvOe4Xnz7aYKxhQUfYu8wNM9uaiNsMz5xwFQ01Ti
         80gwmyhich63MM+Nu5KTebj41tkdUX7Qxth/QcLKTCJyTL8gUTsS6jwDIWkFwx2TLJLl
         BJvx8A0WKTRJA5voxYIBLFgy0AG9QG/87IBrcRX/ba7JmTjq+eKY0jyj2aX08CvaqDm/
         HK74I/cmeCjPKUsLNdb0oAwT4pW9/xMEqTTRJY4KZ9V+5DtJFgr+BWsN2MnQUyA8lDF4
         blZwZ8xD7iLoVidAC1uB4Zb2POC+N/vyt7Vf3Q6ay96EBMbAJR5iK8AjnMz3j0BI+meQ
         fApg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3ehw22GU6NrQDTL+oBdXxN0niE79/e+SUzQT5o4Dv28=;
        b=GFkO+RYJF5/kJOyQ4jdfPLSNNJ+jtC0hckW1mRKuPHLOJEq/qknGrfPot4ql0eBLe8
         SaC/LpJd3ZcypZMHQH7O2qeQe3ZNNnRgCY90POnQq2JVcwlpWgdikjQwyNbSTuGNIMbP
         V/5RPS1NhUK5ktmBw4YeSKB1ooIWjm/Tnz4A/dRqVu4k6BjwFfzgdF7OJz0NZHccS4ji
         T29UPxRCot4tbgdQy5VBtkGYcGz83jNYrF8QS8PxoqVSd+/b7f5ytZl8k/ieT1yiNGMj
         c5MotbVXVnVE3b0E6oFbVEfXxA+CazClUL0+tWiDPuEp5MQpVx/Bbhju01+6Zut4Yc8C
         cFVg==
X-Gm-Message-State: AOAM533k5KRB9Z1GrZYutkxWmG77+xbhKnhkB27ZOGNX1QmHjaFRxRAO
        bLzXusT+wxYlEI6bj9u2DofRaUlMMdi/Sg==
X-Google-Smtp-Source: ABdhPJyrS0rM1ly4S3opodhlMfOgyobXuLtuNIDTHmrQcyzFG5xaOYxWwftU/rArBUInFkffwu7uQQ==
X-Received: by 2002:a92:db05:: with SMTP id b5mr10068160iln.279.1604932976587;
        Mon, 09 Nov 2020 06:42:56 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 192sm7546998ilc.31.2020.11.09.06.42.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 06:42:56 -0800 (PST)
Subject: Re: [PATCH v2 0/2] improve SQPOLL handling
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20201103061600.11053-1-xiaoguang.wang@linux.alibaba.com>
 <71e21e18-69f6-fe24-2a13-1b8269d72393@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <82e42f8a-7f97-4016-ba55-1f460defef26@kernel.dk>
Date:   Mon, 9 Nov 2020 07:42:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <71e21e18-69f6-fe24-2a13-1b8269d72393@linux.alibaba.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/8/20 7:16 AM, Xiaoguang Wang wrote:
> hi,
> 
> A gentle reminder. How does this patch set look now?
> I think the first patch looks ok at least.

I have applied 1/2 for now, I agree that one looks fine and should get
applied. I'll go over 2/2 soonish.

-- 
Jens Axboe

