Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE8E21E1E2
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2020 23:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgGMVKP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jul 2020 17:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgGMVKP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jul 2020 17:10:15 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E39C061755
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 14:10:15 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id v8so15081138iox.2
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 14:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=WJT/QhfISZ+dJvf2DBM+Hvk/CODvbBM5I9Ad3ZEEWFM=;
        b=Q24Qg7RPsJKE/rpCRCV2ubXl4KWv71CseNlkatVX1KzVxtZq/yqmMbzyS+8z/W1S+T
         rm24KgbcS+DjZh+gg4oQpNX1TttdPjVyNdZCXNiTP8E35JU2wUFD6KFthK3bHsu+kkv1
         V0tJTeqK4HVKSqMBTKhpB7tOT6sGAVpLRzR1fHYWzJeOlSIZPAs6r3/41FPr76T1Ag5U
         Lbof7qLHAs4UDTuv1u0NlmnORRqcedteISrFOrWxogAIAAnea2nTyiWHaTPhC+PgawOD
         MCKXWuej4FU5xXa9jCfoOaWLD4BmnPEU47k9eSl1wSQAmKS1LjDYT5OghmqOAR8ozuGp
         eO5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WJT/QhfISZ+dJvf2DBM+Hvk/CODvbBM5I9Ad3ZEEWFM=;
        b=oUQTZGU9zJ2Fv+Z8RqOqZOVFacb57gp0jgIcc3RXYXy5N30gEuZ0u2ZfiZamjuXaSB
         +VpcPoyv3JmujQq3Ug7Qa4pnFo/6PqIpS8PwPfO2sv5FU5N3b6m/SlBf69bsuMKE5+7O
         DvsD1eUvVUqe1W8WBC/UaDdcA8NyIkTQV3dLv2CID+JRjHycMcCM8ZUQOo2JtO9XeyW6
         mUNPCzQzjcNVAPJawSIbC5R6nOXViyP2sd82NnKE9rO3iF0ANfp08MPBWB6xE3sjd/4Q
         QJo0W2Jr76eUgnxK8NVHQcpbW68EfomDr7o3Jy/FvdeOd+bhE7j0jle79gtZaKvQZRQ0
         6Kvg==
X-Gm-Message-State: AOAM533NifzxQRZmmkAQH348WgziTWqVTxM0cv2MGJdc1Unn5vnjlEDy
        pA6GPsXImhbbKujcIssabyT1KfdLtRwtCA==
X-Google-Smtp-Source: ABdhPJwGOd+vgwifwOGsTotSFKIuLFCqziCN4fYCez5TqIVGMBVa569TDoS1XLBpLJW+iRYbjyHGRA==
X-Received: by 2002:a02:cc24:: with SMTP id o4mr2257020jap.105.1594674614290;
        Mon, 13 Jul 2020 14:10:14 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k3sm8767172ils.8.2020.07.13.14.10.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2020 14:10:13 -0700 (PDT)
Subject: Re: [PATCH v2 0/9] scrap 24 bytes from io_kiocb
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1594670798.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9af93bd5-d873-1c14-690b-1eaa592331a4@kernel.dk>
Date:   Mon, 13 Jul 2020 15:10:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1594670798.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/13/20 2:37 PM, Pavel Begunkov wrote:
> Make io_kiocb slimmer by 24 bytes mainly by revising lists usage. The
> drawback is adding extra kmalloc in draining path, but that's a slow
> path, so meh. It also frees some space for the deferred completion path
> if would be needed in the future, but the main idea here is to shrink it
> to 3 cachelines in the end.
> 
> This depends on "rw iovec copy cleanup" series

This looks really good to me, and also tests out good - both in terms
of functionality and KASAN, but also increases performance slightly
as expected. Applied, thanks!

-- 
Jens Axboe

