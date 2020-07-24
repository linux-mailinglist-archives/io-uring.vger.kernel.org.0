Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29FB722CE99
	for <lists+io-uring@lfdr.de>; Fri, 24 Jul 2020 21:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgGXTXN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jul 2020 15:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbgGXTXN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jul 2020 15:23:13 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57750C0619D3
        for <io-uring@vger.kernel.org>; Fri, 24 Jul 2020 12:23:13 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id j19so5865234pgm.11
        for <io-uring@vger.kernel.org>; Fri, 24 Jul 2020 12:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=w2NaCjbBDiQGc9B3pS2XLjC72qctmFrNuT1yGCXH9VI=;
        b=IiZArhaMTedNICtv7CUQvWMMgmFfVzEqCwrvTOCIN0YoqJKczqGOKvZFn81ZdH8LGY
         MQYJjThpc5nCcbh9A6z0bl8G0Fy8pM0Ct/NuYSYOMR/o3ih/S0eY5m9QSf9tK1OoxP2m
         LLUBbVQGM88+iIm4dJxWrkHkTaybtj0OjMcR/hAbL/jCihrsVA8E7INfa0mub79QcyAu
         A5IBwU8IlQu9EgkrdzgKQa9EsQVMn/q8MG7AbU2GgpJEpNxRHB6/9fBI7RMVYpN2+QsO
         AGaoIOWOsQEnOnbxnIVTi7Rr5lh07CyRcj7U+vRN6dc3ww1cYRPLiVToa8xN5MBjPXHm
         bYIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w2NaCjbBDiQGc9B3pS2XLjC72qctmFrNuT1yGCXH9VI=;
        b=VojHWfJ4vYUCceB8Jr7DHZtBJqK26Qj7DxaMO7AvEOBEbmnOpgx/WppuhnB/PDjn9t
         q+VvwqbMNwtN8aDJSldKcY6VVkPe0bGZ1tKdlO4vhBbKppsZgDkpTrZU6tO8uejI5pAm
         pfdi0T36RLh2c9eOVEvSQtkG0ZjHqA+DBwJypCoinWg4geoejk+DltEvqoSy280rBOWj
         qOwTN2oKB1fRtiY9IkmEdnBQE3gI3p1SfihqrRuhD8GgVHA5sKkjNf18VRUcHvTfK9i+
         YUdEuGvcQ+KJLZPcv8bEL3ANoUehPQXZ2sTXku+eGc75fXlV/N47yDVB03iVdgqV8ziT
         gXpQ==
X-Gm-Message-State: AOAM5315CHHAV8yDstvfQjkafFam4tpaAFoPDk1UBNhNF91X4a0EB4wm
        ODNHUHyjNBs6DBLzwN0HTrH1UU3pOjE=
X-Google-Smtp-Source: ABdhPJxW6ahNOOYZmtYW3co4HpYch0LScKdIASVsW4DWyNVC4JyCo+Fz4lCXuK+qT2KBJ1MGNVt6Pg==
X-Received: by 2002:aa7:848b:: with SMTP id u11mr10096230pfn.72.1595618592392;
        Fri, 24 Jul 2020 12:23:12 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id l23sm6386749pjy.45.2020.07.24.12.23.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jul 2020 12:23:11 -0700 (PDT)
Subject: Re: [PATCH 0/2] two 5.8 fixes
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1595610422.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2aa2d8ad-b532-e4ab-5e5b-a9f112b62474@kernel.dk>
Date:   Fri, 24 Jul 2020 13:23:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1595610422.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/24/20 11:07 AM, Pavel Begunkov wrote:
> [2/2] is actually fixed in 5.9, but apparently it wasn't just a
> speculation but rather an actual issue. It fixes locally, by moving
> put out of lock, because don't see a reason why it's there.

Thanks, I applied with the fixed spelling, and shuffled things around
a bit.

-- 
Jens Axboe

