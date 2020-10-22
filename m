Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 406AC296610
	for <lists+io-uring@lfdr.de>; Thu, 22 Oct 2020 22:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S371815AbgJVUjY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 16:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2901257AbgJVUjY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Oct 2020 16:39:24 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D6DC0613CE
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 13:39:24 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id z5so3107712iob.1
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 13:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=fdLgn9PF+OrOW7hXK5dM+CxzAjaneGEKBn3TeSdtTfg=;
        b=IfSlIytkPYe2VpR8u/0y5NWNhntYaKrYq2StMqaksCFhqgBWGbVnWP0bb2MWk0OR18
         TZ40xsWOE83OwgD8aMX4JM5T8HTQC+SrbI9zKEwF5C8JA83HCyQ9Ese+rTJMhIzXNFVh
         kzV/C2HrGcADRmmwmKX0WQZl9b/ghQ4ffHMNKf7AS5zaLGrMAPFyHoAoxQvxQW0K2mMS
         SM4Krxi/NPn3utLzSURptoUgF0L0poQyTmAVHJV5vRnbvKK6lY403yV6076OjsB79ZOS
         MNxL6924DWGHqK1TDDoju0zkXeailVkyr6OFGEdF13e/BHtlrsNv/fnl76aoprqXoN/v
         0fcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fdLgn9PF+OrOW7hXK5dM+CxzAjaneGEKBn3TeSdtTfg=;
        b=g0Prs3o6+VLr5gd9jLaqudvAcEa63/2NWRBtUvDJloEcK18DZXYPUAHglD0ZGSsfd+
         kiZxnp0CD0ikkEcfoDTv2N0AC5awrKWXzbkW0y13Vdg9DkEHfkUKj3VMU1xD5iIOBDUU
         jfheolizIscav+gjbX6zOuxcf+wf+pVmiuLqNPzfF+AQEM3Nc1usMJyHKprzhywyBRze
         azEE+dv5v/Seg0ZxmHPLzDbgdcUDEdX9aqyJYW/T0v83uHgKifRrJYrq+skSjqmXydcZ
         FkcPMqlsx9RUuqwxQ6a1iT8689RWCbRpRlIQERxCBWGgfApwrFw9q10BL0kQLVkO+Pv7
         pe5Q==
X-Gm-Message-State: AOAM532IAnze8tDF8eNyKrSZPEYP1jn1eiaGNZtMmLkuqkCGtCW7iPUc
        gIr87uvaIKvrxehaC78Rgva9pRUuGSvUBA==
X-Google-Smtp-Source: ABdhPJzKOnc7+chDE1jZk0gugO6rPreU3+jr5rh64e6tgdmIRCdCkCkBpFKP9PnXRUfJ1/xra7DE2A==
X-Received: by 2002:a05:6638:211:: with SMTP id e17mr3205812jaq.18.1603399163139;
        Thu, 22 Oct 2020 13:39:23 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h125sm1421065iof.53.2020.10.22.13.39.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2020 13:39:22 -0700 (PDT)
Subject: Re: [PATCH v2] io_uring: remove req cancel in ->flush()
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <6cffe73a8a44084289ac792e7b152e01498ea1ef.1603380957.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <804d44cb-7929-dfc6-0328-16348ebec159@kernel.dk>
Date:   Thu, 22 Oct 2020 14:39:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <6cffe73a8a44084289ac792e7b152e01498ea1ef.1603380957.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/22/20 9:38 AM, Pavel Begunkov wrote:
> Every close(io_uring) causes cancellation of all inflight requests
> carrying ->files. That's not nice but was neccessary up until recently.
> Now task->files removal is handled in the core code, so that part of
> flush can be removed.

Applied, thanks.

-- 
Jens Axboe

