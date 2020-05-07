Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367FA1C9553
	for <lists+io-uring@lfdr.de>; Thu,  7 May 2020 17:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgEGPpb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 May 2020 11:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726538AbgEGPpb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 May 2020 11:45:31 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2070C05BD09
        for <io-uring@vger.kernel.org>; Thu,  7 May 2020 08:45:30 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id d22so2985842pgk.3
        for <io-uring@vger.kernel.org>; Thu, 07 May 2020 08:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=NYaUg5HujR7sQmyawubmYl3hcJlxfTXuEKXFBZh5EIc=;
        b=Ss3kDmHogDZdKj41KkjFqKo8fnHPDSj2KSuSggY8NZeJYcML53gyEaOC3De8TBWgFD
         yuf3Ue9z5v7Vaa7FsC9cHzDfA+CwRr7M41isRpX4c5KEfIoPICoNXdM9e/0IL2Y8S9Je
         Is9tdNgj2qmYAdh+fWyO/3nJOzTa+aGUcdWIVGo0xdN+vdX766K1s6/woXwyb+/nyYbN
         rign7egMM/NP/46hy7V6yL7M3yylWxV3+kzkKbrWJOCG0pvOTCGSmSi8Vl+2KkZIcN84
         D3OUKtQRgVtGUfVa15GznJy0ZCl7sZEUqYzHObPBkL8k70mKDbJ0kU9fsu9O/YvcqCOC
         jz/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NYaUg5HujR7sQmyawubmYl3hcJlxfTXuEKXFBZh5EIc=;
        b=LgTOO5DUp87kKHLwKag1LU11Rnr/Ag6YELWMjFMgPuRcE2WaTgRkFVlxpzR3tAmjh3
         8gV5SrQlHHUGuhpYO7+B9azrw9s47ATnKBvLajsQ20NqB7IITKws2ZbBg4GBI0iFgAFm
         OQYDs7fBl0EfZoPkeWgK/DREG5F2cW4/n4K/nUM9pw96DFRNbuYGvHvUS0E3pKxi4okV
         OqO0Iun231hjYeWBfa09SutdruG0KVOkmYvEjWiUjIdwLhrOQZlMailFzAjIfq0Kre4G
         P7/y9sfJn3Uh6fZllSLjTtEMrAIOTaaVebEqyTvXqYta8rVW0pmx7tc1ozE1xmRgaVG0
         UBGw==
X-Gm-Message-State: AGi0PubA/YFGgQgQZMA0Iggvku2TA3nYurWlgwL0Sw7cdkxFN2gorPdS
        OAXCe/SxlNLwOjNoPqchuP/XWA==
X-Google-Smtp-Source: APiQypKBENGmsna8fKffRP5V2fMNHw/Sxc/xNdBGETyIGoaWr6WO+p7BbERfqYmoehmrWiUYKA2iHg==
X-Received: by 2002:a62:764b:: with SMTP id r72mr14420954pfc.207.1588866329524;
        Thu, 07 May 2020 08:45:29 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21e8::1239? ([2620:10d:c090:400::5:ddfe])
        by smtp.gmail.com with ESMTPSA id n9sm210681pjt.29.2020.05.07.08.45.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 08:45:28 -0700 (PDT)
Subject: Re: [PATCH for-5.7] splice: move f_mode checks to do_{splice,tee}()
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jann Horn <jannh@google.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <51b4370ef70eebf941f6cef503943d7f7de3ea4d.1588621153.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e960f9f6-76ed-5c37-286f-9f8630336520@kernel.dk>
Date:   Thu, 7 May 2020 09:45:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <51b4370ef70eebf941f6cef503943d7f7de3ea4d.1588621153.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/4/20 1:39 PM, Pavel Begunkov wrote:
> do_splice() is used by io_uring, as will be do_tee(). Move f_mode
> checks from sys_{splice,tee}() to do_{splice,tee}(), so they're
> enforced for io_uring as well.

Applied for 5.7, thanks.

-- 
Jens Axboe

