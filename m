Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51BE01C3E1F
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2020 17:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727967AbgEDPHs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 May 2020 11:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727778AbgEDPHr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 May 2020 11:07:47 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8A5C061A0E
        for <io-uring@vger.kernel.org>; Mon,  4 May 2020 08:07:47 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id r2so11564746ilo.6
        for <io-uring@vger.kernel.org>; Mon, 04 May 2020 08:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5Z3xlbtY41Obvx3VFeTjPVi+XDT92TnH75XWU9IHC0Y=;
        b=MS1j0QXVPAGXgAG/zR9xIrf7e2XzERofzzrIL9KRuGkTvzv89LsBD+VV5gs/LlL1p1
         2KFgG2i4vgHR56rDNT4mGCA1xHP6Rgg8lV7aBEIxgxW8+wMrG1m+nE9iA5SfbKiCj83b
         9B3ZdDrI9EOFbaUzelLDxZyUl92yvGhypfD2LEchS6OXEFjFctiQqXcW18lsJ+szC9I6
         5ZNwucs9U+pmkgOoiG3iovKGdxBfjNQi/hsWXzXZ0pejx9mshoWYAt4Fe4FLfvbEaK42
         cUnof3S2Bvi/EkV0JkqYt5/3elJafhJZYa5gogj9sXlez97AX6CcGxmcj9cV1JBFyp95
         dN1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5Z3xlbtY41Obvx3VFeTjPVi+XDT92TnH75XWU9IHC0Y=;
        b=DEBfLlGEqgt3qNnDDNOICNIf9+xf71qIzUoLHPngz46rhqOaAxAXyoWGwgZX5IrROk
         au2jI9+rvtXPM6k6G7fPfNv+1JKGpM4mYOAZnvvuuDK5cxUoGxa/Ccj7ntKyrT+rFXbg
         bjzc0h8D0NaqMrWE+fSnWSVE2HoCEs7SyVtdVKZ+7vR7sQseSA22TDg5RDE7vHDSC/zn
         fHRejhkULLa5S4+MEBgYtXudkDF7qdiI+r9Ks7hJC78UwY2Hb4IJ+3+4JoLFrz/IzMi5
         bGWdjc6NCAlNZRXzCU6Dw3D7a9hZWpEQsZE/darkThl6hanlMrJInEOE6LI+INbFfhxW
         TDCg==
X-Gm-Message-State: AGi0PubcTlLvvfF5f9nhPx9Ri9ndls3vZsrdI3MQzUWLSsqjoy/zMhNo
        YniKqvTV67RYViWjuETa6E1gWHAQQjR0nA==
X-Google-Smtp-Source: APiQypJoqbSAINYpVTKxwgtas33pmR90ZsPW+eHPHNao6HPmEe7g9CPTrMfVRlAeOe+CKVyLWvl9hQ==
X-Received: by 2002:a92:d443:: with SMTP id r3mr16888708ilm.293.1588604866835;
        Mon, 04 May 2020 08:07:46 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id x75sm5184030ill.33.2020.05.04.08.07.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 08:07:46 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix mismatched finish_wait() calls in
 io_uring_cancel_files()
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200426075443.30215-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <21a202e1-5ab4-b07c-f7cf-546f4fd5b113@kernel.dk>
Date:   Mon, 4 May 2020 09:07:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200426075443.30215-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/26/20 1:54 AM, Xiaoguang Wang wrote:
> The prepare_to_wait() and finish_wait() calls in io_uring_cancel_files()
> are mismatched. Currently I don't see any issues related this bug, just
> find it by learning codes.

Applied, thanks.

-- 
Jens Axboe

