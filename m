Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF5683FCDFC
	for <lists+io-uring@lfdr.de>; Tue, 31 Aug 2021 22:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240921AbhHaTjz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Aug 2021 15:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240905AbhHaTjz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Aug 2021 15:39:55 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF45C061575
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 12:38:59 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id b200so272049iof.13
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 12:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=EVR4v+PXjebuwtlj3GJMm0eofWTjdgfryY264x5dvp0=;
        b=lahEAUToUr02rh0XRiZ6BcMnXnB5eyUeDcW72U+nH6ZFTS/CavVAyr6e5TGNWYFs7/
         fSb9kDMV4zsq8mL6p/JEW2a4M89Ek/cGpwVm9LDTMVep74XzjRMh4pbkWFuGzrWL5WEr
         cK0VSwbgKq9vtw7CfG97lC2/tyWlzS3rZnyTa9s7dfxQiZoC7cEWYb6DMublxLuKisVm
         tn2NyYqldhbVO+1ICqQLfinK/yJAta12HFMltCCbwI0o5dxBFkrybScHbX8hKJ0UYg9+
         wYtlhrzZv+XFvirG13rulQdhTSeZdfYAuRteIHL6ZnqhQfJtz6G2vL5jGmYI/v2I3MgY
         yXVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EVR4v+PXjebuwtlj3GJMm0eofWTjdgfryY264x5dvp0=;
        b=X5mugKORKi2iatqzZCfucHjXWn0fuIDso81KT3alBbiw4G7YRstGWLX4eE+m2HvOtK
         9hIFjKiN2aglScyngLl1feH0yGovy906mB/Y4G7VNsq4fi29avU6HZgjQ/9cglQyF/Mj
         DT9iafo6DZY7i4+ASHr6tOEcbKNAcDUz7mKQ6FYbK+tQf/yAOGI0/fosejGBNW3IY61Y
         nCHYkiEPKF4WeoJ2JjiAD9GZVY4VNktqubslAs00cISAiWDkoTKn1Tc9ERqviFVnq1YY
         CIOz9rb0/A5ftijRxhxyuv1plDodKiQat6g4C7jGn5FxJVSj0wKh8UV51o2PeNsID4/8
         oCZw==
X-Gm-Message-State: AOAM533FtletoZieJEgfMbibCXCL07ondMNTdeYXqZZXoGxZ+DZCQ3PW
        KhWmvXsnsexnA/DZ/muY1G/zsXl4l/xNfg==
X-Google-Smtp-Source: ABdhPJyMHF6pYRWH8+taj8iN2f7VNvxBVSypwYAVL3LEJo9bh9UOXtM/AVXm/eR/uz97hzNakYUGtQ==
X-Received: by 2002:a5e:a813:: with SMTP id c19mr24129114ioa.199.1630438738660;
        Tue, 31 Aug 2021 12:38:58 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id h9sm10722448ioz.30.2021.08.31.12.38.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 12:38:58 -0700 (PDT)
Subject: Re: [PATCH liburing v2] man: document new register/update API
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <f456c80bb8795eb7b8c3db8279206d94ce148587.1630436406.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5b59ddc1-143d-2855-5dbc-8648fdb9f6fe@kernel.dk>
Date:   Tue, 31 Aug 2021 13:38:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f456c80bb8795eb7b8c3db8279206d94ce148587.1630436406.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/31/21 1:05 PM, Pavel Begunkov wrote:
> Document
> - IORING_REGISTER_FILES2
> - IORING_REGISTER_FILES_UPDATE2,
> - IORING_REGISTER_BUFFERS2
> - IORING_REGISTER_BUFFERS_UPDATE,
> 
> And add a couple of words on registered resources (buffers, files)
> tagging.

Great, thanks! I made a few minor edits while applying.

-- 
Jens Axboe

